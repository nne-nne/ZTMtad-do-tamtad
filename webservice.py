import requests


class Webservice:
    def __int__(self):
        pass

    def exampleRequest(self):
        x = requests.get(url="https://ckan2.multimediagdansk.pl/shapes?date=2023-01-15&routeId=10606&tripId=371")
        print(x.text)
