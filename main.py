import webservice
import user_input
from DataLoader import DataLoader
from pprint import pprint

data_loader = DataLoader().full_prepare()
webService = webservice.Webservice()
user_input = user_input.UserInput(data_loader)


if __name__ == '__main__':
    #pprint(data_loader.stop_dict)
    user_input.are_stops_connected_dialogue()
    pass
