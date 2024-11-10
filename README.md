# Pogodi_Drzavu

The "Guess the Country" app is designed for iPad to provide an interactive, fun way to learn geography. It challenges players to identify countries by their borders displayed on a map, aiming to enhance users' geographic knowledge through gameplay. The app supports multiplayer mode for 2-4 players, who compete by answering quickly and accurately to score points. Points are awarded based on response speed—5 points for the fastest, down to 1 point for the slowest correct response, with incorrect answers earning zero points.

Users can customize the game by selecting continents (e.g., Europe, Asia), the number of rounds (3, 5, 7, or 10), and round duration (5, 10, or 15 seconds). Country boundary data is stored on Firebase, which also saves player scores after each game for progress tracking and performance analysis.

The app uses several classes to manage different functions:

**QuestionAnswerGenerator** selects a country and generates multiple-choice options for each question. <br/>
**MapViewModel** loads and displays geoJSON data on the map. <br/>
**QuizViewModel** handles game dynamics, such as round progression, score tracking, and time limits. <br/>
**SettingsViewModel** allows players to customize game settings, like adding players and game options. <br/>
**WelcomeViewModel** displays the introductory screen with a brief delay. <br/>
**ResultsViewModel** enhances the competitive experience by displaying player scores in a ranked leaderboard format. <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 13 32](https://github.com/user-attachments/assets/0d312e61-3153-405a-a7db-f3d06dc6852c)
Welcome View
<br/> <br/> <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 14 03](https://github.com/user-attachments/assets/9e7eacc8-fd36-4f4a-abfd-b9233923df1f)
Settings View
<br/> <br/> <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 18 15](https://github.com/user-attachments/assets/8b136771-d748-4015-9907-4df9f0d554d7)
Map View - Selected country
<br/> <br/> <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 18 28](https://github.com/user-attachments/assets/696da9c0-b3d5-4a4c-a202-233d19cd09dd)
Qiuz View - Selecting answers - 4 Players
<br/> <br/> <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 18 50](https://github.com/user-attachments/assets/22a4f11a-8e8b-4fdd-917f-4ba2fc7eface)
Quiz View - Correct/Uncorrect answers and points - 4 Players
<br/> <br/> <br/>

![Simulator Screenshot - iPad (10th generation) - 2024-06-18 at 20 23 28](https://github.com/user-attachments/assets/23862f7c-fc79-40ca-8594-866d9a4fc8ae)
Results View
<br/> <br/> <br/>
