import requests
from pprint import pprint
from datetime import datetime, timedelta


class TimetableLoader:
    def __init__(self):
        self.cache = dict()

    def load(self, routeId, day):
        if routeId not in self.cache.keys():
            data = requests.get(f'https://ckan2.multimediagdansk.pl/stopTimes?date={day}&routeId={routeId}').json()
            self.cache.update({routeId: data})
        else:
            data = self.cache[routeId]
        return data

    def decode_departure(self, departure):
        routeId = departure['routeId']
        # day, time = .split()
        try:
            time = datetime.strptime(departure['theoreticalTime'], '%Y-%m-%dT%H:%M:%SZ')
            time = time + timedelta(hours=1)
        except:
            time = datetime.strptime(departure['departureTime'], '%Y-%m-%dT%H:%M:%S')

        day, hour = time.strftime('%Y-%m-%dT%H:%M:%S').split('T')
        return routeId, day, hour

    def find_dep(self, routeId, day, time, stopId, nextId):
        data = self.load(routeId, day)['stopTimes']
        index, specific_trip = self.find_specific(stopId, time, data)
        target = self.find_first_matched(specific_trip, nextId, data[index:])
        return target

    def find_next(self, routeId, tripId, day, stopId, time):
        data = self.load(routeId, day)['stopTimes']
        t = datetime.strptime(time, '%H:%M:%S')
        for x in data:
            if x['stopId'] == stopId \
                    and datetime.strptime(x['departureTime'].split('T')[1], '%H:%M:%S') > t \
                    and x['tripId'] == tripId:
                x.update({'departureTime': x['date']+'T'+x['departureTime'].split('T')[1]})
                return x
        pass

    def find_specific(self, stopId, time, data):
        for i, x in enumerate(data):
            if x['stopId'] == stopId and x['departureTime'].split('T')[1] == time:
                return i, x

    def find_first_matched(self, specific_trip, nextId, data):
        for i, x in enumerate(data):
            if x['tripId'] == specific_trip['tripId'] and x['stopId'] == nextId:
                return x


if __name__ == '__main__':
    data = TimetableLoader().find_dep(6, '2023-01-12', '12:02:00', 201, 2231)
    pprint(data)
