
# Deployment for ioFog on Kubernetes

## Rationale

Eclipse ioFog brings an operator for Kubernetes. However, this approach as multiple downsides, the most important one
is that is requires "cluster admin" privileges. Other approaches requires the ability to remotely SSH into nodes,
allowing password-less sudo access. Altogether, not ideal. This repository tries to offer a sane way to deploy this
into Kubernetes, and cleans up a few issues on the agent side too.

## Patches

The following patches are changes on top of the Eclipse ioFog 2.0-ish version:

* `iofogctl`
  * The tool only allows to log in to a controller with port `51121`. However, some people might actually have proper
    API endpoints, and so enforcing this doesn't make any sense. So there is patch to remove the behavior.
* Controller
  * The builder image uses a Node 8 based image, which fails to get some dependencies. This repository changes this
    to a Node 14 build and updates some dependencies to make it compatible with this newer Node version.
  * The base directory of the PID cannot be configured. The process tries to write to a path inside the container
    image which is immutable. There is a patch which allows to configure the base directory of the PID files.
* ECV-Viewer
  * The ECN-Viewer constructs a URL to the API, which again enforces the port `51121`, and also tries to use the viewer
    URL as the API endpoint. As you can easily configure the API information on the server side, there is patch
    which simply sets the URL to the API, which the viewer will use.
  * The ECN-Viewer pings `ip-api.com` in order to get the location of the user. However, it can only do that with
    `http` (as `https` requires some token). And so, the browser will see this as a mixed mode request, if the
    viewer itself is served over HTTPS. This repository removes this behavior.
* Agent
  * Both the builder and the agent image use extremely outdated base images and Java versions. This repository changes
    this to use more recent base images based on UBI8.
  * Instead of running the SystemV init script, the container directly starts the JVM with the appropriate JAR file. 
    This is required as the UBI8 image has no idea about SystemV.
  * The agent has a baked-in TLS certificate, which is the only allowed server side trust anchor. If you have a server
    side certificate which is accepted by standard OS trust anchors, this won't work. So there is a patch in this agent
    to also use the system trust anchors in addition.
  * Change the configuration of the random source, pointing Java to the random source, instead of re-wiring the file
    system using symbolic links, which breaks in some build scenarios.

## Register an agent

### Ubuntu

* Get patched `iofogctl` version

* Install docker
  
  ~~~shell
  sudo apt install docker.io
  ~~~

* Register agent
  
  * Create the configuration file `register.yaml`
    ~~~yaml
    apiVersion: iofog.org/v2
    kind: AgentConfig
    metadata:
      name: agent-1
    spec:
      name: agent-1
      host: iofog-agent-1
    ~~~
  
  * Then register the agent
    
    ~~~shell
    iofogctl deploy -f register.yaml
    ~~~

* Deploy agent

  * Create the deployment file `deploy.yaml`
    
    ~~~yaml
    apiVersion: iofog.org/v2
    kind: LocalAgent
    metadata:
      name: agent-1
    spec:
      container:
        image: quay.io/ctrontesting/iofog-agent:latest
    ~~~

  * Then deploy the agent

    ~~~shell
    iofogctl deploy -f deploy.yaml
    ~~~

## Deploy workload

~~~yaml
apiVersion: iofog.org/v2
kind: Application
metadata:
  name: hello-web
spec:
~~~

