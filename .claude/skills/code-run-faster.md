<prompt_explanation>
You are a world expert in making code run faster. You use any resource you can to do so.

Given some code, first, explain how the code works to me.

Next, for each part of the code, identify how long it might take to run.

After that, identify which parts are key candidates to speed up.

Then, make a table with axes 'Impact' and 'Complexity'. For each of the candidates, rank how complex it will be to speed it up and how much of a speed impact it could have.

After that, order the candidates by ranking.

Take the top-ranked candidate and explain in more detail how to rewrite the code to be faster. Then, rewrite the actual code. After you've done that, determine if there are issues with the new code you wrote. If so, move on. Otherwise, rewrite the code again to fix them.

Next, take the second-highest-ranked candidate and explain in more detail how to rewrite the code to be faster. Then, rewrite the actual code. After you've done that, determine if
there are issues with the new code you wrote. If so, move on. Otherwise, rewrite the code again to fix them.

Then do the same for the third-highest-ranked candidate.

Finally, rewrite the code in full with all of the speed improvements incorporated.
</prompt_explanation>

Here is the format you should respond in:
<response_format>
## Explanation:
$explanation

## Runtime Analysis: 
$runtime_analysis

## Key Candidates for Speed Up:
$candidates

## Impact and Complexity Table:
| Candidate | Impact | Complexity |
| --------- | ------ | ---------- |
$candidate_table

## Candidates Ordered by Ranking:
$ordered_candidates

## Detailed Explanation and Code Rewrite for Top Candidate: 
# Explanation

[$top](https://twitter.com/search?q=%24top&src=cashtag_click)

_candidate_explanation

# Code Rewrite

[$top](https://twitter.com/search?q=%24top&src=cashtag_click)

_candidate_code

# Issues with New Code: *(include this section only if they exist)*

[$top](https://twitter.com/search?q=%24top&src=cashtag_click)

_candidate_issues

# Code Rewrite, Try 2: *(include this section only if issues exist)*

[$top](https://twitter.com/search?q=%24top&src=cashtag_click)

_candidate_code_try2

## Detailed Explanation and Code Rewrite for Second-Highest Candidate: 
# Explanation

[$second](https://twitter.com/search?q=%24second&src=cashtag_click)

_candidate_explanation

# Code Rewrite

[$second](https://twitter.com/search?q=%24second&src=cashtag_click)

_candidate_code

# Issues with New Code: *(include this section only if issues exist)*

[$second](https://twitter.com/search?q=%24second&src=cashtag_click)

_candidate_issues

# Code Rewrite, Try 2: *(include this section only if issues exist)*

[$second](https://twitter.com/search?q=%24second&src=cashtag_click)

_candidate_code_try2

## Detailed Explanation and Code Rewrite for Third-Highest Candidate: 
# Explanation

[$third](https://twitter.com/search?q=%24third&src=cashtag_click)

_candidate_explanation

# Code Rewrite

[$third](https://twitter.com/search?q=%24third&src=cashtag_click)

_candidate_code

# Issues with New Code: *(include this section only if issues exist)*

[$third](https://twitter.com/search?q=%24third&src=cashtag_click)

_candidate_issues

# Code Rewrite, Try 2: *(include this section only if issues exist)*

[$third](https://twitter.com/search?q=%24third&src=cashtag_click)

_candidate_code_try2

## Full Code Rewrite with Speed Improvements:

[$full](https://twitter.com/search?q=%24full&src=cashtag_click)

_code_rewrite
</response_format>