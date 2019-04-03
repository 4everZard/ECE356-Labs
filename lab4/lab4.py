import pandas as pd
import numpy as np
from sklearn import tree
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_iris
from sklearn.preprocessing import LabelEncoder
import pydot 

def runTest(df, test_num):
    # Split data into 80/20
    x_train, x_test, y_train, y_test = train_test_split (
        df.drop("inducted", axis=1),
        df["inducted"],
        test_size=0.2,
        shuffle=True
    )

    # Train and test decision tree for both gini and entropy index
    iris = load_iris()
    gini = DecisionTreeClassifier()
    gini.fit(X=x_train, y=y_train)
    accuracy_gini = gini.score(X=x_test, y=y_test)

    entropy = DecisionTreeClassifier(criterion="entropy")
    entropy.fit(X=x_train, y=y_train)
    accuracy_entropy = entropy.score(X=x_test, y=y_test)

    tree.export_graphviz(gini, out_file='gini.dot')
    tree.export_graphviz(entropy, out_file='entropy.dot')

    gini_iteration_tree_name = ("gini_tree_{}.png".format(test_num))
    (gini_graph,) = pydot.graph_from_dot_file('gini.dot')
    gini_graph.write_png(gini_iteration_tree_name)

    entropy_iteration_tree_name = ("entropy_tree_{}.png".format(test_num))
    (entropy_graph,) = pydot.graph_from_dot_file('entropy.dot')
    entropy_graph.write_png(entropy_iteration_tree_name)

    # Predict the test results
    gini_prediction_results = gini.predict(X=x_test)
    gini_prediction_results = gini_prediction_results.tolist()

    entropy_prediction_results = entropy.predict(X=x_test)
    entropy_prediction_results = entropy_prediction_results.tolist()

    return {
        "accuracy_gini": accuracy_gini,
        "accuracy_entropy": accuracy_entropy
    }


if __name__ == "__main__":
    df = pd.read_csv("results.csv")
    df = df.fillna(0)
    playerID_le = LabelEncoder()
    playerID_le.fit(df["playerID"])
    df["playerID"] = playerID_le.transform(df["playerID"])

    inducted_le = LabelEncoder()
    inducted_le.fit(df["inducted"])
    df["inducted"] = inducted_le.transform(df["inducted"])
    
    gini_df = pd.DataFrame(columns=["Dataset number", "Accuracy"])
    entropy_df = pd.DataFrame(columns=["Dataset number", "Accuracy"])

    for i in range(5):
        res = runTest(df, i)
        gini_df = gini_df.append({"Dataset number": i+1, "Accuracy": res["accuracy_gini"]}, ignore_index=True)
        entropy_df = entropy_df.append({"Dataset number": i+1, "Accuracy": res["accuracy_entropy"]}, ignore_index=True)
        print("Finished Test {}".format(i+1))
        print(res)

    gini_df.to_csv("g4_DT_gini.csv")
    entropy_df.to_csv("g4_DT_entropy.csv")

