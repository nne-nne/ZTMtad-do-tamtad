import requests


class Webservice:
    def __int__(self):
        pass

    def exampleRequest(self):
        x = requests.get(url="https://ckan2.multimediagdansk.pl/shapes?date=2023-01-15&routeId=10606&tripId=371")
        print(x.text)

    def stopsRequest(self) -> str:
        response = requests.get(url="https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/4c4025f0-01bf-41f7-a39f-d156d201b82b/download/stops.json")
        return response.text
