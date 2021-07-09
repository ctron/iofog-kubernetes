* [ ] Create default router

  ~~~
  TOKEN=$(iofog-controller user generate-token -e admin@my.cluster | jq -r .accessToken )
  http -v PUT https://api-iofog.apps.wonderful.iot-playground.org/api/v3/router Authorization:$TOKEN host=router-iofog.apps.wonderful.iot-playground.org
  ~~~

* [ ] Create certificates for router network
* [ ] Deploy "port manager" (check if that is required)
