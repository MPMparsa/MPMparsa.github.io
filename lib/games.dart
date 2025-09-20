import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart'; // Import to use AppColors

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This page immediately shows the chess setup dialog upon being built.
    // It's a clean way to handle the entry point for the single game.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showChessSetupDialog(context);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offline Games'),
        backgroundColor: AppColors.cardColor,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameCard(
              title: 'Chess',
              icon: FontAwesomeIcons.chess,
            ),
          ],
        ),
      ),
    );
  }
}

void _showChessSetupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      int selectedTime = 10;
      // StatefulBuilder is used here so only the dialog rebuilds on state change.
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Setup Chess Game'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Time per player (minutes):'),
                // Using Wrap for better responsiveness on small screens
                Wrap(
                  spacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [5, 10, 15].map((time) {
                    return ChoiceChip(
                      label: Text('$time min'),
                      selected: selectedTime == time,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          setState(() => selectedTime = time);
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(MaterialPageRoute( // Go to the game
                    builder: (context) => ChessGamePage(initialTime: Duration(minutes: selectedTime)),
                  ));
                },
                child: const Text('Start Game'),
              )
            ],
          );
        },
      );
    },
  );
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const GameCard({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      child: SizedBox(
        width: 200,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, color: AppColors.textHeader)),
          ],
        ),
      ),
    );
  }
}


// --- CHESS GAME ---
class ChessGamePage extends StatelessWidget {
  final Duration initialTime;
  const ChessGamePage({required this.initialTime, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pass-and-Play Chess'), backgroundColor: AppColors.cardColor),
      body: Center(child: ChessGame(initialTime: initialTime)),
    );
  }
}


class ChessGame extends StatefulWidget {
  final Duration initialTime;
  const ChessGame({required this.initialTime, super.key});

  @override
  ChessGameState createState() => ChessGameState();
}

class ChessGameState extends State<ChessGame> {
  List<List<ChessPiece?>> board = [];
  int? selectedRow;
  int? selectedCol;
  bool isWhiteTurn = true;

  Timer? _timer;
  late Duration whiteTime;
  late Duration blackTime;

  @override
  void initState() {
    super.initState();
    whiteTime = widget.initialTime;
    blackTime = widget.initialTime;
    _resetBoard();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel(); // Ensure no multiple timers are running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (isWhiteTurn) {
          if (whiteTime.inSeconds > 0) {
            whiteTime -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            _showWinnerDialog(false);
          }
        } else {
          if (blackTime.inSeconds > 0) {
            blackTime -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            _showWinnerDialog(true);
          }
        }
      });
    });
  }

  void _resetBoard() {
    board = List.generate(8, (row) => List.generate(8, (col) => null));
    // Pawns
    for (int i = 0; i < 8; i++) {
      board[1][i] = ChessPiece(type: PieceType.pawn, isWhite: false);
      board[6][i] = ChessPiece(type: PieceType.pawn, isWhite: true);
    }
    // Rooks
    board[0][0] = board[0][7] = ChessPiece(type: PieceType.rook, isWhite: false);
    board[7][0] = board[7][7] = ChessPiece(type: PieceType.rook, isWhite: true);
    // Knights
    board[0][1] = board[0][6] = ChessPiece(type: PieceType.knight, isWhite: false);
    board[7][1] = board[7][6] = ChessPiece(type: PieceType.knight, isWhite: true);
    // Bishops
    board[0][2] = board[0][5] = ChessPiece(type: PieceType.bishop, isWhite: false);
    board[7][2] = board[7][5] = ChessPiece(type: PieceType.bishop, isWhite: true);
    // Queens
    board[0][3] = ChessPiece(type: PieceType.queen, isWhite: false);
    board[7][3] = ChessPiece(type: PieceType.queen, isWhite: true);
    // Kings
    board[0][4] = ChessPiece(type: PieceType.king, isWhite: false);
    board[7][4] = ChessPiece(type: PieceType.king, isWhite: true);
  }

  void _showWinnerDialog(bool isWhiteWinner) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(isWhiteWinner ? "White Wins!" : "Black Wins!"),
      content: const Text("Time has run out."),
      actions: [TextButton(onPressed: () {
        setState(() {
          _resetBoard();
          whiteTime = widget.initialTime;
          blackTime = widget.initialTime;
          isWhiteTurn = true;
          startTimer();
          Navigator.of(context).pop();
        });
      }, child: const Text("Play Again"))],
    ));
  }


  void _onTileTap(int row, int col) {
    setState(() {
      // If it's black's turn, we need to translate the tap to the correct coordinates
      int effectiveRow = isWhiteTurn ? row : 7 - row;
      int effectiveCol = isWhiteTurn ? col : 7 - col;

      if (selectedRow == null) {
        if (board[effectiveRow][effectiveCol] != null && board[effectiveRow][effectiveCol]!.isWhite == isWhiteTurn) {
          selectedRow = effectiveRow;
          selectedCol = effectiveCol;
        }
      } else {
        final piece = board[selectedRow!][selectedCol!];
        if (piece != null) {
          board[effectiveRow][effectiveCol] = piece;
          board[selectedRow!][selectedCol!] = null;
          isWhiteTurn = !isWhiteTurn;
        }
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This makes the layout scrollable on very small screens, fixing overflows.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TimerDisplay(isTurn: !isWhiteTurn, time: blackTime, label: "Black"),
                TimerDisplay(isTurn: isWhiteTurn, time: whiteTime, label: "White"),
              ],
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
                decoration: BoxDecoration(border: Border.all(color: AppColors.secondary)),
                child: AnimatedRotation(
                  turns: isWhiteTurn ? 0 : 0.5,
                  duration: const Duration(milliseconds: 400),
                  child: GridView.builder(
                    itemCount: 64,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                    itemBuilder: (context, index) {
                      int row = index ~/ 8;
                      int col = index % 8;
                      bool isLightSquare = (row + col) % 2 == 0;

                      int effectiveRow = isWhiteTurn ? row : 7 - row;
                      int effectiveCol = isWhiteTurn ? col : 7 - col;

                      bool isSelected = effectiveRow == selectedRow && effectiveCol == selectedCol;

                      return GestureDetector(
                        onTap: () => _onTileTap(row, col),
                        child: Container(
                          color: isSelected ? Colors.green.withAlpha(150) : (isLightSquare ? const Color(0xFFF0D9B5) : const Color(0xFFB58863)),
                          child: board[effectiveRow][effectiveCol] != null
                              ? Center(child: RotatedBox(
                              quarterTurns: isWhiteTurn ? 0 : 2,
                              child: board[effectiveRow][effectiveCol]!.getIcon()))
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final Duration time;
  final String label;
  final bool isTurn;

  const TimerDisplay({super.key, required this.time, required this.label, required this.isTurn});

  String _formatDuration(Duration d) {
    return "${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isTurn ? AppColors.secondary : AppColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: isTurn ? AppColors.background : AppColors.textHeader, fontSize: 20)),
            const SizedBox(height: 8),
            Text(_formatDuration(time), style: TextStyle(color: isTurn ? AppColors.background : AppColors.textHeader, fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

enum PieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final PieceType type;
  final bool isWhite;

  ChessPiece({required this.type, required this.isWhite});

  Icon getIcon() {
    Color color = isWhite ? Colors.white70 : Colors.black87;
    switch (type) {
      case PieceType.pawn: return Icon(FontAwesomeIcons.chessPawn, color: color, size: 40);
      case PieceType.rook: return Icon(FontAwesomeIcons.chessRook, color: color, size: 40);
      case PieceType.knight: return Icon(FontAwesomeIcons.chessKnight, color: color, size: 40);
      case PieceType.bishop: return Icon(FontAwesomeIcons.chessBishop, color: color, size: 40);
      case PieceType.queen: return Icon(FontAwesomeIcons.chessQueen, color: color, size: 40);
      case PieceType.king: return Icon(FontAwesomeIcons.chessKing, color: color, size: 40);
    }
  }
}

