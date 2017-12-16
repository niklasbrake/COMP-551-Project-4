# COMP 551: Applied Machine Learning
Professor Joelle Pineau

## Project 4 Outline
Background: One of the challenges in machine learning research is to ensure that published results are
reliable and reproducible. In support of this, the goal of this project is to investigate reproducibility of
empirical results submitted to the International Conference on Learning Representations (iclr.cc). Papers
submitted to the conferences are available for public review:
https://openreview.net/group?id=ICLR.cc/2018/Conference

You should select a paper from this list, and aim to replicate the experiments described in the paper. The
goal is to assess if the experiments are reproducible, and to determine if the conclusions of the paper are
supported by your findings. You do not need to reproduce all experiments in your selected paper, for
example the authors may experiment with a new method that requires more GPUs than you have access
to, but also present results for a baseline method (e.g. simple logistic regression), in which case you could
elect to reproduce only the baseline results. It is sometimes the case that baseline methods are not
properly implemented, or hyper-parameter search is not done with the same degree of attention. You can
implement algorithms from scratch, or use any existing toolbox or software, including code released by the
authors, as long as you reference everything appropriately in your report.

The result of the reproducibility study should NOT be a simple Pass / Fail outcome. The goal should be to
identify which parts of the contribution can be reproduced, and at what cost in terms of resources
(computation, time, people, development effort, communication with the authors). Essentially, think of your
role as an inspector verifying the validity of the experimental results and conclusions of the paper