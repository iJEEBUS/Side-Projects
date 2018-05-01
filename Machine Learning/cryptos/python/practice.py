import pandas as pd
from matplotlib import pyplot as plt

df = pd.read_csv('./crypto-markets.csv', sep=',')

ripple_df = df[df['symbol'] == 'XRP']

print(ripple_df.head())