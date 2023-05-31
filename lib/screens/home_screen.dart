import 'package:flutter/material.dart';
import 'package:tic_tac/screens/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  String result = '';
  int turn = 0;
  bool gameOver = false;
  Game game = Game();

  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SwitchListTile.adaptive(
                  activeColor: Colors.blue,
                  title: const Text(
                    'Tow Player',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: gameOver ? isSwitch = false : isSwitch,
                  onChanged: (newValue) {
                    setState(() {
                      isSwitch = newValue;
                    });
                  }),
              const SizedBox(
                height: 30,
              ),
              Text(
                gameOver ? '' : '$activePlayer TURN',
                style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: GridView.count(
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                  crossAxisCount: 3,
                  children: List.generate(
                    9,
                    (index) => InkWell(
                      onTap: gameOver ? null : () => onTap(index),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration:  const Duration(
                          milliseconds: 500,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Player.playerX.contains(index)
                              ? Colors.amber
                              : Player.playerO.contains(index)
                                  ? Colors.blueAccent.shade400
                                  : Colors.black45,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade900.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            Player.playerX.contains(index)
                                ? 'X'
                                : Player.playerO.contains(index)
                                    ? 'O'
                                    : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                result,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black45),
                    elevation: const MaterialStatePropertyAll(10),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      Player.playerX = [];
                      Player.playerO = [];
                      activePlayer = 'X';
                      result = '';
                      turn = 0;
                      gameOver = false;
                    });
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Restart The Game'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onTap(int index) async {
    if (!Player.playerX.contains(index) && !Player.playerO.contains(index)) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitch && !gameOver) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      if (activePlayer == 'X') {
        activePlayer = 'O';
      } else {
        activePlayer = 'X';
      }
      turn++;

      String winnerPlayer = game.chickWinner();
      if (winnerPlayer != '') {
        result = 'Player $winnerPlayer Won';
        gameOver = true;
      } else if (turn == 9) {
        result = 'Undecided Game';
        gameOver = true;
      }
    });
  }
}
