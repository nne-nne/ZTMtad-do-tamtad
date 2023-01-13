class Path:
    def __init__(self, total_time: int, path_segments, arrival_time: str):
        self.total_time = total_time
        self.path_segments = path_segments
        self.arrival_time = arrival_time # clocktime of arrival at the target

    def to_json(self):
        segment_jsons = []
        for p in self.path_segments:
            segment_jsons.append(p.to_json())
        return {'total_time': self.total_time, 'path_segments': segment_jsons, 'arrival_time': self.arrival_time}


class PathSegment:
    def __init__(self, route, route_type, minutes, departure_time, stop_desc):
        self.route = route,
        self.routeType = route_type,  # bus or train or what?
        self.minutes = minutes,  # how long does this segment take in minutes
        self.departureTime = departure_time,  # departure time
        self.stop_desc = stop_desc,  # stopDesc of departure stop for this path_segment

    def to_json(self):
        return {'route': self.route,
                'route_type': self.routeType,
                'minutes': self.minutes,
                'departure_time': self.departureTime,
                'stop_desc': self.stop_desc}
