import numpy as np
import pandas as pd
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', default='./analyze_padding_data.tcl')
    parser.add_argument('--output', default='../output_data/analyze_slack_time.csv')
    parser.add_argument('--time', default='10')
    args = parser.parse_args()
    data = []
    with open(args.input, 'r') as f:
        for line in f.readlines():
            tmp = line.split()
            if (len(tmp) == 2):
                data.append(tmp)
    new_data = np.array(data, dtype=np.float32)

    d = {('cycle:'+args.time) : new_data[:,0], 'slack': new_data[:,1]}
    df = pd.DataFrame(data=d)
    df.to_csv(args.output, index=False)

