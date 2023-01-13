from DataLoader import DataLoader
from threading import Thread

from WayFinder import WayFinder


def get_stop_list_by_name(stops, stop_name):
    result = []
    for stop in stops:
        name = stop['stopDesc']
        if name is None:
            continue

        if stop_name == name:
            result.append(stop['stopId'])
    return result


def run_finder(from_id, to_id, results, index):
    dl = DataLoader().full_prepare()
    wf = WayFinder(dl)
    results[index] = WayFinder(dl).complex_find(from_id, to_id)


def find_connection(stop_from, stop_to, dataLoader):
    stops = dataLoader.stops['2023-01-13']['stops']
    stops_from = get_stop_list_by_name(stops, stop_from)
    stops_to = get_stop_list_by_name(stops, stop_to)

    combination_num = len(stops_from) * len(stops_to)

    threads = [None] * combination_num
    results = [None] * combination_num

    i = 0
    for stop_from in stops_from:
        for stop_to in stops_to:
            threads[i] = Thread(target=run_finder, args=(stop_from, stop_to, results, i))
            threads[i].start()
            i += 1

    # do some other stuff

    for i in range(combination_num):
        threads[i].join()

    print(results)
    return results
