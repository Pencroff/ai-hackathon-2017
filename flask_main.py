from flask import Flask
import requests as r
import json
from difflib import SequenceMatcher

app = Flask(__name__)
api_key = 'DEMO_KEY'


@app.route("/compare/<param_food_name>", methods=['GET'])
def compare(param_food_name):
    # food_collection = get_product_list(param_food_name)
    food_collection = [(0, 'whatever'), (1, 'other thing')]
    optimum_result = 0
    best_ratio = 0
    for t in food_collection:
        food_id, food_name = t
        ratio = distance(param_food_name, food_name)
        if ratio > best_ratio:
            best_ratio = ratio
            optimum_result = food_id

    # food_elements = r.get('http://example.com').content
    # return food_elements
    return str(optimum_result)


def get_product_list(q=''):
#   https://api.nal.usda.gov/ndb/search/?format=json&q=butter&sort=n&max=25&offset=0&api_key=DEMO_KEY
    url_root = 'https://api.nal.usda.gov/ndb/search/?q={query}&format={format}&sort={sort}&max={records_limit}&&offset={offset}&api_key={api_key}'
    params = { 'format': 'json', 'offset': 0, 'records_limit': 10, 'sort': 'n', 'api_key': api_key, 'query': q }
    resp = r.get(url_root.format_map(params))
    data = json.loads(resp._content)
    result = list([(x['ndbno'], x['name']) for x in data['list']['item']])
    return result


def distance(a, b):
    return SequenceMatcher(None, a, b).ratio()

if __name__ == "__main__":
    app.run()
