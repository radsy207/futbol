# Futbol

### **Abstract**
---
In this repo, the user is able to pull statistics about a Futbol league by calling specific methods.

### **Collaborators**
---
- [Carol Rieping](https://github.com/eelektra)
- [David Marino](https://github.com/radsy207)
- [Jasmine Hamou](https://github.com/hamouj)
- [Nickolas Marquez](https://github.com/NickolasAM)

### **Reflection**
---
1. What was the most challenging aspect of this project?

    After delegating responsibilities, we realized that certain methods were much more involved than others, and that the original delegation needed revising. We quickly realized that having multiple people working on the same project had its challenges, including trying to avoid merge conflicts. Additionally, working with CSV data for the first time, it was difficult to conceptualize. Making names for variables and helper methods was another difficulty.

1. What was the most exciting aspect of this project?

    It was exciting to watch our progress as we worked through the data and methods. Getting a test to pass, especially on a complicated method, was a great feeling. Refactoring was also a highlight as it allowed us to look at each other's methods and get insight into how another coder problem solves. Finishing the project, we can recognize the growth we have made by collaborating and tackling a new concpet (CSV data).

1. Describe the best choice enumerables you used in your project. Please include file names and line numbers.

    When trying to determine the highest or lowest within a hash, we utilized the max_by and min_by enumerables to pull the key-value pair by highest/lowest value. In the ./lib/season_stats.rb line 156, we used max_by on the season_tackles_by_team hash to pull the key-value pair that contained the highest value (number of tackles).

1. Tell us about a module or superclass which helped you re-use code across repository classes. Why did you choose to use a superclass and/or a module?

    We used inheritance to create a StatData superclass which housed all the CSV files and parsed them to be accessible within the child classes. This allowed us to pass state to the child class and reduced repetition within the #initialize method. Additionally, creating classes for each set of statistics, we were able to abstract our logic and encapsulate them in child classes.

1. Tell us about 1) a unit test and 2) an integration test that you are particularly proud of. Please include file name(s) and line number(s).

    - Unit Test: #offense_hash from ./lib/league_stats.rb, test on ./spec/league_stats_spec.rb lines 30-34
      The offense_hash helper method returns a hash in which the keys are team IDs and the values are the average goals for that team.a
      This tests the method in isolation, making it a unit test.

    - Integration Test: #best_offense from ./lib/league_stats.rb, test on ./spec/league_stats_spec.rb lines 36-40
      The #best_offense method returns the name of the team with the highest average number of goals scored per game. It is reliant on the #offense_hash and #teams_and_goals_data methods, making it an integration test. In order for #best_offense to pass, the other methods need to fulfill their functions.

1. Is there anything else you would like instructors to know?

    We were very intentional when creating our sample data set for our spec tests. We pulled 10 games per season, played by 13 teams. In doing this, we ensured that we had enough variety to test edge cases while also making the data set small enough to write meaningful tests. By utilizing our sample data set and running the spec harness which used the full data set, we proved that our methods were polymorphic.

### **Questions**
---
Nickolas: Should we prefer repetition over more lines of code when refactoring? For example, in the GameStats class, there were 4 methods that had the same formula to calculate the value. I created a private method that could be used in place of rewriting the formulas within each method. This made the code DRY, but created more lines of code. Which takes priority, DRY code or volume/lines of code?

David: At what point does abstraction create confusion? In one case, creating helper methods reduces the amount of lines in the main method, but it also leaves any developer who picks up the program on a chase of the helper methods; they are having to constantly search for helper methods called within main methods, especially if a helper method is used in a much later method within the class.

Carol: Is CSV data an array of hashes?

Jasmine: What is the benefit of creating a class for each data set (games, game_teams, teams) with instance variables assigned to each column versus the way we chose to structure it?
