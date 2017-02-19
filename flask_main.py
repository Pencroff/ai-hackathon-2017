from flask import Flask
from flask import jsonify
import requests as r
import json
# import distance
from sklearn.feature_extraction.text import CountVectorizer
from scipy.spatial.distance import jaccard

app = Flask(__name__)
api_key = 'DEMO_KEY'


@app.route("/compare/<param_food_name>", methods=['GET'])
def get_food_details(param_food_name):
    food_collection = get_product_list(param_food_name)
    optimum_result = get_best_matched_item(param_food_name, food_collection)
    # best_ratio = 1000
    # for t in food_collection:
    #     food_id, food_name = t
    #     ratio = get_ratio(param_food_name, food_name)
    #     if ratio < best_ratio:
    #         best_ratio = ratio
    #         optimum_result = food_id
    print(optimum_result)
    return get_product_detail(optimum_result[0])


def get_product_list(q=''):
    #   https://api.nal.usda.gov/ndb/search/?format=json&q=butter&sort=n&max=25&offset=0&api_key=DEMO_KEY
    url_root = 'https://api.nal.usda.gov/ndb/search/?q={query}&format={format}&sort={sort}&max={records_limit}&&offset={offset}&api_key={api_key}'
    params = {'format': 'json', 'offset': 0, 'records_limit': 1000, 'sort': 'n', 'api_key': api_key, 'query': q}
    resp = r.get(url_root.format_map(params))
    data = json.loads(resp._content)
    result = []
    if 'list' in data:
        result = list([(x['ndbno'], x['name']) for x in data['list']['item']])
    return result


def get_product_detail(product_id):
    #   https://api.nal.usda.gov/ndb/reports/?ndbno=01009&type=f&format=json&api_key=DEMO_KEY
    url_root = 'https://api.nal.usda.gov/ndb/reports/?ndbno={product_id}&format={format}&type={type}&api_key={api_key}'
    params = { 'format': 'json', 'type': 'f', 'api_key': api_key, 'product_id': product_id }
    result = 'None'
    if product_id is not None:
        resp = r.get(url_root.format_map(params))
        data = json.loads(resp._content)
        result = {}
        print(data['report'])
        if 'report' in data:
            item = data['report']['food']
            result['id'] = item['ndbno']
            result['name'] = item['name']
            result['nutrient_list'] = []
            nutrients = item['nutrients']
            for n_item in nutrients:
                print(n_item)
                if n_item['nutrient_id'] == '208' or n_item['nutrient_id'] == 208:
                    result['nutrient_list'].append({
                        'name': 'energy',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })
                if n_item['nutrient_id'] == '203' or n_item['nutrient_id'] == 203:
                    result['nutrient_list'].append({
                        'name': 'protein',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })
                if n_item['nutrient_id'] == '204' or n_item['nutrient_id'] == 204:
                    result['nutrient_list'].append({
                        'name': 'fat',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })
                if n_item['nutrient_id'] == '205' or n_item['nutrient_id'] == 205:
                    result['nutrient_list'].append({
                        'name': 'carbohydrate',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })
                if n_item['nutrient_id'] == '291' or n_item['nutrient_id'] == 291:
                    result['nutrient_list'].append({
                        'name': 'fiber',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })
                if n_item['nutrient_id'] == '269' or n_item['nutrient_id'] == 291:
                    result['nutrient_list'].append({
                        'name': 'sugar',
                        'value': n_item['value'],
                        'unit': n_item['unit']
                    })

    return jsonify(result)

def get_best_matched_item(q, lst):
    txt_data = [x[1] for x in lst]
    vectorizer = CountVectorizer(min_df=1)
    X = vectorizer.fit_transform(txt_data)
    req_X = vectorizer.transform([q]).toarray()
    for idx, item in enumerate(X):
        lst[idx] = (lst[idx][0], lst[idx][1], jaccard(item.toarray(), req_X))
    best_item = min(lst, key=lambda x: x[2])
    return best_item

def get_ratio(a, b):
    return 1 #distance.levenshtein(a, b)

if __name__ == "__main__":
    app.run(debug=True)
