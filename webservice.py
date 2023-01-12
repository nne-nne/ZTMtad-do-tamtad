import requests
import json


class Webservice:
    def __int__(self):
        pass

    def getJson(self, url):
        x = requests.get(url=url)
        return json.loads(x.text)

    def exampleRequest(self):
        x = requests.get(url="https://ckan2.multimediagdansk.pl/shapes?date=2023-01-15&routeId=10606&tripId=371")
        print(x.text)

    def stopsRequest(self):
        response = requests.get(url="https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/4c4025f0-01bf-41f7-a39f-d156d201b82b/download/stops.json")
        return json.loads(response.text)

    #def stopsForToday(self):
       # json = self.stopsRequest()
#return json['2023-']

    def routesRequest(self):
        response = requests.get(
            url="https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/da610d2a-7f54-44d1-b409-c1a7bdb4d3a4/download/shapes.json")
        return json.loads(response.text)
