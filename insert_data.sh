#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    #get team_id
    WINNER_ID=$($PSQL "select team_id from teams where name like '$winner'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name like '$opponent'")
    # not found winner_id
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_ID=$($PSQL "insert into teams(name) values('$winner')")
      #get new winner_id
      WINNER_ID=$($PSQL "select team_id from teams where name like '$winner'")
    fi
    #not found opponent_id
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_ID=$($PSQL "insert into teams(name) values('$opponent')")
      #get new opponent_id
      OPPONENT_ID=$($PSQL "select team_id from teams where name like '$opponent'")
    fi
  fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    #get team_id
    WINNER_ID=$($PSQL "select team_id from teams where name like '$winner'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name like '$opponent'")
    #insert games table
    INSERT_GAMES_TABLE=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
  fi
done