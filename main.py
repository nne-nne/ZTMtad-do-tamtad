import webservice
import user_input
from DataLoader import DataLoader
from pprint import pprint

data_loader = DataLoader().full_prepare()
webService = webservice.Webservice()
user_input = user_input.UserInput(data_loader)


if __name__ == '__main__':
    user_input.departures_dialogue()
    pass
