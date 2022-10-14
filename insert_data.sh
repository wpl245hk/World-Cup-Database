#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  #Skip 1st row
  if [[ ! $year == 'year' ]]
  then
    
    #Insert teams
    #Insert winner name
    if [[ -z $($PSQL "SELECT team_id FROM teams WHERE name='$winner'") ]]
    then
      INSERT_teams=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      
    fi

    #Insert opponent name
    if [[ -z $($PSQL "SELECT team_id FROM teams WHERE name='$opponent'") ]]
    then
      INSERT_teams=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    fi

    #Insert games
    WINID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    INSERT_games=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINID, $OPPONENTID, $winner_goals, $opponent_goals)")
  fi


done



