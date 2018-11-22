from slackclient import SlackClient
import os

search_query = "ワークスペース"
slack_token = os.getenv("SLACK_TOKEN")
client = SlackClient(slack_token)

# チャンネルのリストを取得する関数
def channel_list(client):
    channels = client.api_call("channels.list")
    channels = channels['channels']
    return [channel['name'] for channel in channels]

# クエリから検索を行う
def search_all(client, search_query):
    messages = client.api_call("search.messages", query=search_query)
    messages = messages['messages']['matches']
    result_texts = [message['text'] for message in messages]
    result_url = [message['permalink'] for message in messages]
    return result_texts, result_url

# print(channel_list(client))
result = search_all(client, search_query)
for text, url in zip(result[0], result[1]):
    print(text)
    print(url)
