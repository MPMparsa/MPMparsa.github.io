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
  // --- STATE VARIABLES ---
  late List<List<ChessPiece?>> board;
  bool isWhiteTurn = true;

  int? selectedRow;
  int? selectedCol;

  // Stores valid moves for the currently selected piece as a list of [row, col]
  List<List<int>> validMoves = [];

  // Stores the last move made for en passant rule. Format: [fromRow, fromCol, toRow, toCol]
  List<int>? lastMove;

  // King positions are tracked to quickly check for checks.
  late List<int> whiteKingPos;
  late List<int> blackKingPos;

  Timer? _timer;
  late Duration whiteTime;
  late Duration blackTime;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    whiteTime = widget.initialTime;
    blackTime = widget.initialTime;
    isWhiteTurn = true;
    lastMove = null;
    _resetBoard();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (isWhiteTurn) {
          if (whiteTime.inSeconds > 0) {
            whiteTime -= const Duration(seconds: 1);
          } else {
            _showWinnerDialog(false, "Black wins on time!");
          }
        } else {
          if (blackTime.inSeconds > 0) {
            blackTime -= const Duration(seconds: 1);
          } else {
            _showWinnerDialog(true, "White wins on time!");
          }
        }
      });
    });
  }

  void _resetBoard() {
    board = List.generate(8, (_) => List.generate(8, (_) => null));
    // Place pieces with hasMoved = false
    for (int i = 0; i < 8; i++) {
      board[1][i] = ChessPiece(type: PieceType.pawn, isWhite: false);
      board[6][i] = ChessPiece(type: PieceType.pawn, isWhite: true);
    }
    board[0][0] = ChessPiece(type: PieceType.rook, isWhite: false);
    board[0][7] = ChessPiece(type: PieceType.rook, isWhite: false);
    board[7][0] = ChessPiece(type: PieceType.rook, isWhite: true);
    board[7][7] = ChessPiece(type: PieceType.rook, isWhite: true);

    board[0][1] = ChessPiece(type: PieceType.knight, isWhite: false);
    board[0][6] = ChessPiece(type: PieceType.knight, isWhite: false);
    board[7][1] = ChessPiece(type: PieceType.knight, isWhite: true);
    board[7][6] = ChessPiece(type: PieceType.knight, isWhite: true);

    board[0][2] = ChessPiece(type: PieceType.bishop, isWhite: false);
    board[0][5] = ChessPiece(type: PieceType.bishop, isWhite: false);
    board[7][2] = ChessPiece(type: PieceType.bishop, isWhite: true);
    board[7][5] = ChessPiece(type: PieceType.bishop, isWhite: true);

    board[0][3] = ChessPiece(type: PieceType.queen, isWhite: false);
    board[7][3] = ChessPiece(type: PieceType.queen, isWhite: true);

    board[0][4] = ChessPiece(type: PieceType.king, isWhite: false);
    board[7][4] = ChessPiece(type: PieceType.king, isWhite: true);

    // Set initial king positions
    blackKingPos = [0, 4];
    whiteKingPos = [7, 4];
  }

  void _showWinnerDialog(bool isWhiteWinner, String message) {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isWhiteWinner ? "White Wins!" : "Black Wins!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _resetGame());
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  void _showDrawDialog(String message) {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Draw"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _resetGame());
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  // --- CORE GAME LOGIC ---

  void _onTileTap(int row, int col) {
    setState(() {
      int effectiveRow = isWhiteTurn ? row : 7 - row;
      int effectiveCol = col;

      final tappedPiece = board[effectiveRow][effectiveCol];

      // If a friendly piece is tapped
      if (tappedPiece != null && tappedPiece.isWhite == isWhiteTurn) {
        selectedRow = effectiveRow;
        selectedCol = effectiveCol;
        validMoves = _calculateRealValidMoves(effectiveRow, effectiveCol, tappedPiece);
      }
      // If a valid move square is tapped
      else if (selectedRow != null && validMoves.any((m) => m[0] == effectiveRow && m[1] == effectiveCol)) {
        _makeMove(selectedRow!, selectedCol!, effectiveRow, effectiveCol);
      }
    });
  }

  void _makeMove(int fromRow, int fromCol, int toRow, int toCol) {
    final piece = board[fromRow][fromCol]!;

    // Handle special moves
    // En Passant
    if (piece.type == PieceType.pawn && (toRow - fromRow).abs() == 1 && (toCol - fromCol).abs() == 1 && board[toRow][toCol] == null) {
      int capturedPawnRow = isWhiteTurn ? toRow + 1 : toRow - 1;
      board[capturedPawnRow][toCol] = null;
    }
    // Castling
    if (piece.type == PieceType.king && (toCol - fromCol).abs() == 2) {
      if (toCol == 6) { // Kingside
        board[fromRow][5] = board[fromRow][7];
        board[fromRow][7] = null;
        board[fromRow][5]!.hasMoved = true;
      } else { // Queenside
        board[fromRow][3] = board[fromRow][0];
        board[fromRow][0] = null;
        board[fromRow][3]!.hasMoved = true;
      }
    }

    // Make the move
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = null;
    piece.hasMoved = true;

    // Update king position if moved
    if (piece.type == PieceType.king) {
      if (piece.isWhite) {
        whiteKingPos = [toRow, toCol];
      } else {
        blackKingPos = [toRow, toCol];
      }
    }

    // Pawn Promotion
    if (piece.type == PieceType.pawn && (toRow == 0 || toRow == 7)) {
      _showPawnPromotionDialog(toRow, toCol);
    } else {
      _endTurn();
    }
  }

  void _endTurn() {
    // Update last move for en passant
    lastMove = [selectedRow!, selectedCol!, validMoves.firstWhere((m) => m[0] == selectedRow! && m[1] == selectedCol!, orElse: () => [0,0,0,0])[2], validMoves.firstWhere((m) => m[0] == selectedRow! && m[1] == selectedCol!, orElse: () => [0,0,0,0])[3]];

    isWhiteTurn = !isWhiteTurn;
    selectedRow = null;
    selectedCol = null;
    validMoves.clear();

    // Check for checkmate or stalemate
    if (_isGameEnd()) {
      return;
    }
  }

  bool _isGameEnd() {
    List<List<int>> allPossibleMoves = [];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] != null && board[r][c]!.isWhite == isWhiteTurn) {
          allPossibleMoves.addAll(_calculateRealValidMoves(r, c, board[r][c]!));
        }
      }
    }

    if (allPossibleMoves.isEmpty) {
      if (_isKingInCheck(isWhiteTurn)) {
        _showWinnerDialog(!isWhiteTurn, "Checkmate!");
      } else {
        _showDrawDialog("Stalemate!");
      }
      return true;
    }
    return false;
  }

  // --- MOVE CALCULATION ---

  List<List<int>> _calculateRealValidMoves(int row, int col, ChessPiece piece) {
    List<List<int>> pseudoMoves = [];
    switch (piece.type) {
      case PieceType.pawn: pseudoMoves = _calculatePawnMoves(row, col, piece); break;
      case PieceType.rook: pseudoMoves = _calculateSlidingMoves(row, col, piece, [[1, 0], [-1, 0], [0, 1], [0, -1]]); break;
      case PieceType.knight: pseudoMoves = _calculateKnightMoves(row, col, piece); break;
      case PieceType.bishop: pseudoMoves = _calculateSlidingMoves(row, col, piece, [[1, 1], [1, -1], [-1, 1], [-1, -1]]); break;
      case PieceType.queen: pseudoMoves = _calculateSlidingMoves(row, col, piece, [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]); break;
      case PieceType.king: pseudoMoves = _calculateKingMoves(row, col, piece); break;
    }

    List<List<int>> realValidMoves = [];
    for (var move in pseudoMoves) {
      if (!_isMovePuttingKingInCheck(row, col, move[0], move[1])) {
        realValidMoves.add(move);
      }
    }
    return realValidMoves;
  }

  bool _isMovePuttingKingInCheck(int fromR, int fromC, int toR, int toC) {
    // Simulate the move on a temporary board
    ChessPiece? piece = board[fromR][fromC];
    ChessPiece? capturedPiece = board[toR][toC];
    List<int> originalKingPos = piece!.isWhite ? List.from(whiteKingPos) : List.from(blackKingPos);

    board[toR][toC] = piece;
    board[fromR][fromC] = null;
    if (piece.type == PieceType.king) {
      if (piece.isWhite) {
        whiteKingPos = [toR, toC];
      } else {
        blackKingPos = [toR, toC];
      }
    }

    bool inCheck = _isKingInCheck(piece.isWhite);

    // Revert the move
    board[fromR][fromC] = piece;
    board[toR][toC] = capturedPiece;
    if (piece.type == PieceType.king) {
      if (piece.isWhite) {
        whiteKingPos = originalKingPos;
      } else {
        blackKingPos = originalKingPos;
      }
    }

    return inCheck;
  }

  bool _isKingInCheck(bool isWhiteKing) {
    List<int> kingPos = isWhiteKing ? whiteKingPos : blackKingPos;
    return _isSquareAttacked(kingPos[0], kingPos[1], !isWhiteKing);
  }

  bool _isSquareAttacked(int r, int c, bool byWhite) {
    // Check for attacks from all directions
    // Pawns
    int dir = byWhite ? 1 : -1;
    if (_isValid(r + dir, c - 1) && board[r + dir][c - 1]?.type == PieceType.pawn && board[r+dir][c-1]?.isWhite == byWhite) return true;
    if (_isValid(r + dir, c + 1) && board[r + dir][c + 1]?.type == PieceType.pawn && board[r+dir][c+1]?.isWhite == byWhite) return true;
    // Knights
    var knightDirs = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]];
    for (var d in knightDirs) {
      if (_isValid(r + d[0], c + d[1]) && board[r + d[0]][c + d[1]]?.type == PieceType.knight && board[r+d[0]][c+d[1]]?.isWhite == byWhite) return true;
    }
    // Sliding pieces (Rook, Bishop, Queen)
    var slidingDirs = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]];
    for(var d in slidingDirs) {
      for(int i = 1; i < 8; i++) {
        int newR = r + d[0] * i;
        int newC = c + d[1] * i;
        if (!_isValid(newR, newC)) break;
        var p = board[newR][newC];
        if (p != null) {
          if (p.isWhite == byWhite) {
            if (p.type == PieceType.queen) return true;
            if (p.type == PieceType.rook && (d[0].abs() + d[1].abs() == 1)) return true;
            if (p.type == PieceType.bishop && (d[0].abs() + d[1].abs() == 2)) return true;
          }
          break;
        }
      }
    }
    // King
    for(int i = -1; i<=1; i++) {
      for(int j = -1; j<=1; j++) {
        if(i==0 && j==0) continue;
        if(_isValid(r+i, c+j) && board[r+i][c+j]?.type == PieceType.king && board[r+i][c+j]?.isWhite == byWhite) return true;
      }
    }

    return false;
  }

  // --- PIECE-SPECIFIC MOVE GENERATION ---

  List<List<int>> _calculatePawnMoves(int r, int c, ChessPiece p) {
    List<List<int>> moves = [];
    int dir = p.isWhite ? -1 : 1;
    // Move forward
    if (_isValid(r + dir, c) && board[r + dir][c] == null) {
      moves.add([r + dir, c]);
      // First move two squares
      if (!p.hasMoved && _isValid(r + 2 * dir, c) && board[r + 2 * dir][c] == null) {
        moves.add([r + 2 * dir, c]);
      }
    }
    // Capture
    if (_isValid(r + dir, c - 1) && board[r + dir][c - 1]?.isWhite == !p.isWhite) moves.add([r + dir, c - 1]);
    if (_isValid(r + dir, c + 1) && board[r + dir][c + 1]?.isWhite == !p.isWhite) moves.add([r + dir, c + 1]);

    // En Passant
    if (lastMove != null) {
      if (lastMove![0] == r + 2 * dir && lastMove![2] == r && (lastMove![3] - c).abs() == 1) {
        if(board[r][lastMove![3]]?.type == PieceType.pawn) {
          moves.add([r + dir, lastMove![3]]);
        }
      }
    }

    return moves;
  }

  List<List<int>> _calculateKnightMoves(int r, int c, ChessPiece p) {
    var moves = <List<int>>[];
    var directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]];
    for (var d in directions) {
      int newR = r + d[0], newC = c + d[1];
      if (_isValid(newR, newC) && board[newR][newC]?.isWhite != p.isWhite) {
        moves.add([newR, newC]);
      }
    }
    return moves;
  }

  List<List<int>> _calculateKingMoves(int r, int c, ChessPiece p) {
    var moves = <List<int>>[];
    var directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
    for (var d in directions) {
      int newR = r + d[0], newC = c + d[1];
      if (_isValid(newR, newC) && board[newR][newC]?.isWhite != p.isWhite) {
        moves.add([newR, newC]);
      }
    }
    // Castling
    if (!p.hasMoved && !_isKingInCheck(p.isWhite)) {
      // Kingside
      if (board[r][c+1] == null && board[r][c+2] == null && board[r][c+3]?.hasMoved == false) {
        if (!_isSquareAttacked(r, c+1, !p.isWhite) && !_isSquareAttacked(r, c+2, !p.isWhite)) {
          moves.add([r, c+2]);
        }
      }
      // Queenside
      if (board[r][c-1] == null && board[r][c-2] == null && board[r][c-3] == null && board[r][c-4]?.hasMoved == false) {
        if (!_isSquareAttacked(r, c-1, !p.isWhite) && !_isSquareAttacked(r, c-2, !p.isWhite)) {
          moves.add([r, c-2]);
        }
      }
    }
    return moves;
  }

  List<List<int>> _calculateSlidingMoves(int r, int c, ChessPiece p, List<List<int>> directions) {
    var moves = <List<int>>[];
    for (var d in directions) {
      for (int i = 1; i < 8; i++) {
        int newR = r + d[0] * i, newC = c + d[1] * i;
        if (!_isValid(newR, newC)) break;
        if (board[newR][newC] == null) {
          moves.add([newR, newC]);
        } else {
          if (board[newR][newC]!.isWhite != p.isWhite) moves.add([newR, newC]);
          break;
        }
      }
    }
    return moves;
  }

  bool _isValid(int r, int c) => r >= 0 && r < 8 && c >= 0 && c < 8;

  // --- PAWN PROMOTION ---

  void _showPawnPromotionDialog(int row, int col) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Promote Pawn"),
          content: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: [
              _buildPromotionChoice(PieceType.queen, row, col),
              _buildPromotionChoice(PieceType.rook, row, col),
              _buildPromotionChoice(PieceType.bishop, row, col),
              _buildPromotionChoice(PieceType.knight, row, col),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromotionChoice(PieceType type, int row, int col) {
    return GestureDetector(
      onTap: () {
        setState(() {
          board[row][col] = ChessPiece(type: type, isWhite: isWhiteTurn);
          Navigator.of(context).pop();
          _endTurn();
        });
      },
      child: Card(
        color: AppColors.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChessPiece(type: type, isWhite: isWhiteTurn).getIcon(),
        ),
      ),
    );
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                child: GridView.builder(
                  itemCount: 64,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;
                    int effectiveRow = isWhiteTurn ? row : 7 - row;
                    int effectiveCol = col;

                    bool isLightSquare = (row + col) % 2 == 0;
                    bool isSelected = effectiveRow == selectedRow && effectiveCol == selectedCol;
                    bool isValidMove = validMoves.any((m) => m[0] == effectiveRow && m[1] == effectiveCol);

                    return GestureDetector(
                      onTap: () => _onTileTap(row, col),
                      child: Container(
                        color: isSelected
                            ? Colors.green.withAlpha(200)
                            : isLightSquare
                            ? const Color(0xFFF0D9B5)
                            : const Color(0xFFB58863),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (board[effectiveRow][effectiveCol] != null)
                              Center(child: board[effectiveRow][effectiveCol]!.getIcon()),
                            if (isValidMove)
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(100),
                                    shape: BoxShape.circle,
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
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
  bool hasMoved;

  ChessPiece({
    required this.type,
    required this.isWhite,
    this.hasMoved = false,
  });

  Icon getIcon() {
    Color color = isWhite ? Colors.white70 : Colors.black87;
    double size = 40.0;
    switch (type) {
      case PieceType.pawn: return Icon(FontAwesomeIcons.chessPawn, color: color, size: size);
      case PieceType.rook: return Icon(FontAwesomeIcons.chessRook, color: color, size: size);
      case PieceType.knight: return Icon(FontAwesomeIcons.chessKnight, color: color, size: size);
      case PieceType.bishop: return Icon(FontAwesomeIcons.chessBishop, color: color, size: size);
      case PieceType.queen: return Icon(FontAwesomeIcons.chessQueen, color: color, size: size);
      case PieceType.king: return Icon(FontAwesomeIcons.chessKing, color: color, size: size);
    }
  }
}

