program TrashRoyaleClone;

uses
  Crt;

const
  ELIXIR_MAX = 10;
  BASE_ELIXIR_RATE = 0.357; { 1 / 2.8 }
  ARENA_WIDTH = 50; { Simplified text-based arena dimensions }
  ARENA_HEIGHT = 25;
  RIVER_POS = 12; { Middle of the arena }
  FPS = 10; { Slower FPS for text-based game }

type
  TCard = record
    Name: string[20];
    Cost: Integer;
    HP: Integer;
    Dmg: Integer;
    Speed: Real;
    Range: Integer;
    AttackSpeed: Real;
    PreferBuilding: Boolean;
    Count: Integer;
  end;

  TUnit = record
    X, Y: Integer; { Grid-based position }
    HP: Integer;
    Dmg: Integer;
    Speed: Real;
    Range: Integer;
    AttackSpeed: Real;
    Cooldown: Integer;
    Team: string[10];
    PreferBuilding: Boolean;
    Name: string[20];
    Active: Boolean;
  end;

  TBuilding = record
    X, Y: Integer;
    HP: Integer;
    Dmg: Integer;
    Range: Integer;
    AttackSpeed: Real;
    Cooldown: Integer;
    Team: string[10];
    IsKing: Boolean;
    Active: Boolean;
  end;

var
  AllCards: array[1..4] of TCard;
  Units: array[1..20] of TUnit;
  NumUnits: Integer;
  Buildings: array[1..6] of TBuilding;
  PlayerDeck: array[1..4] of TCard;
  PlayerHand: array[1..4] of TCard;
  PlayerElixir: Real;
  OppElixir: Real;
  GameOver: Boolean;
  GameTime: Real;
  PlayerHandSize: Integer;

procedure InitCards;
begin
  AllCards[1].Name := 'Knight'; AllCards[1].Cost := 3; AllCards[1].HP := 1400; AllCards[1].Dmg := 160;
  AllCards[1].Speed := 1.2; AllCards[1].Range := 1; AllCards[1].AttackSpeed := 1.1;
  AllCards[1].PreferBuilding := False; AllCards[1].Count := 1;
  AllCards[2].Name := 'Archers'; AllCards[2].Cost := 3; AllCards[2].HP := 200; AllCards[2].Dmg := 40;
  AllCards[2].Speed := 0.96; AllCards[2].Range := 5; AllCards[2].AttackSpeed := 0.9;
  AllCards[2].PreferBuilding := False; AllCards[2].Count := 2;
  AllCards[3].Name := 'Giant'; AllCards[3].Cost := 5; AllCards[3].HP := 3000; AllCards[3].Dmg := 200;
  AllCards[3].Speed := 0.8; AllCards[3].Range := 1; AllCards[3].AttackSpeed := 1.5;
  AllCards[3].PreferBuilding := True; AllCards[3].Count := 1;
  AllCards[4].Name := 'Goblins'; AllCards[4].Cost := 2; AllCards[4].HP := 67; AllCards[4].Dmg := 33;
  AllCards[4].Speed := 1.6; AllCards[4].Range := 1; AllCards[4].AttackSpeed := 0.8;
  AllCards[4].PreferBuilding := False; AllCards[4].Count := 3;
end;

procedure InitTowers;
begin
  { Player towers }
  Buildings[1].X := 10; Buildings[1].Y := 20; Buildings[1].HP := 2500; Buildings[1].Dmg := 90;
  Buildings[1].Range := 5; Buildings[1].AttackSpeed := 0.8; Buildings[1].Team := 'player';
  Buildings[1].IsKing := False; Buildings[1].Active := True;
  Buildings[2].X := 40; Buildings[2].Y := 20; Buildings[2].HP := 2500; Buildings[2].Dmg := 90;
  Buildings[2].Range := 5; Buildings[2].AttackSpeed := 0.8; Buildings[2].Team := 'player';
  Buildings[2].IsKing := False; Buildings[2].Active := True;
  Buildings[3].X := 25; Buildings[3].Y := 22; Buildings[3].HP := 4000; Buildings[3].Dmg := 120;
  Buildings[3].Range := 4; Buildings[3].AttackSpeed := 1.0; Buildings[3].Team := 'player';
  Buildings[3].IsKing := True; Buildings[3].Active := True;
  { Opponent towers }
  Buildings[4].X := 10; Buildings[4].Y := 5; Buildings[4].HP := 2500; Buildings[4].Dmg := 90;
  Buildings[4].Range := 5; Buildings[4].AttackSpeed := 0.8; Buildings[4].Team := 'opp';
  Buildings[4].IsKing := False; Buildings[4].Active := True;
  Buildings[5].X := 40; Buildings[5].Y := 5; Buildings[5].HP := 2500; Buildings[5].Dmg := 90;
  Buildings[5].Range := 5; Buildings[5].AttackSpeed := 0.8; Buildings[5].Team := 'opp';
  Buildings[5].IsKing := False; Buildings[5].Active := True;
  Buildings[6].X := 25; Buildings[6].Y := 3; Buildings[6].HP := 4000; Buildings[6].Dmg := 120;
  Buildings[6].Range := 4; Buildings[6].AttackSpeed := 1.0; Buildings[6].Team := 'opp';
  Buildings[6].IsKing := True; Buildings[6].Active := True;
end;

procedure DrawArena;
var
  X, Y, I: Integer;
begin
  ClrScr;
  { Draw arena border }
  for X := 1 to ARENA_WIDTH do
  begin
    GotoXY(X, 1); Write('#');
    GotoXY(X, ARENA_HEIGHT); Write('#');
  end;
  for Y := 1 to ARENA_HEIGHT do
  begin
    GotoXY(1, Y); Write('#');
    GotoXY(ARENA_WIDTH, Y); Write('#');
  end;
  { Draw river }
  for X := 1 to ARENA_WIDTH do
  begin
    GotoXY(X, RIVER_POS); Write('~');
  end;
  { Draw units }
  for I := 1 to NumUnits do
    if Units[I].Active then
    begin
      GotoXY(Units[I].X, Units[I].Y);
      if Units[I].Team = 'player' then
        Write('P')
      else
        Write('O');
    end;
  { Draw towers }
  for I := 1 to 6 do
    if Buildings[I].Active then
    begin
      GotoXY(Buildings[I].X, Buildings[I].Y);
      if Buildings[I].IsKing then
        Write('K')
      else
        Write('T');
    end;
  { Draw elixir and hand }
  GotoXY(1, ARENA_HEIGHT + 1);
  Write('Elixir: ', Round(PlayerElixir):2, '/10');
  GotoXY(1, ARENA_HEIGHT + 2);
  Write('Hand: ');
  for I := 1 to PlayerHandSize do
    Write(I, ':', PlayerHand[I].Name, ' ');
end;

procedure Deploy(Card: TCard; X, Y: Integer; Team: string);
var
  I: Integer;
begin
  if Team = 'player' then
  begin
    if (PlayerElixir < Card.Cost) or (Y < RIVER_POS) then Exit;
    PlayerElixir := PlayerElixir - Card.Cost;
  end
  else
  begin
    if (OppElixir < Card.Cost) or (Y > RIVER_POS) then Exit;
    OppElixir := OppElixir - Card.Cost;
  end;
  for I := 1 to Card.Count do
  begin
    if NumUnits < 20 then
    begin
      Inc(NumUnits);
      Units[NumUnits].X := X + (I - 1) * 2;
      Units[NumUnits].Y := Y;
      Units[NumUnits].HP := Card.HP;
      Units[NumUnits].Dmg := Card.Dmg;
      Units[NumUnits].Speed := Card.Speed;
      Units[NumUnits].Range := Card.Range;
      Units[NumUnits].AttackSpeed := Card.AttackSpeed;
      Units[NumUnits].Cooldown := 0;
      Units[NumUnits].Team := Team;
      Units[NumUnits].PreferBuilding := Card.PreferBuilding;
      Units[NumUnits].Name := Card.Name;
      Units[NumUnits].Active := True;
    end;
  end;
end;

procedure FindTarget(var U: TUnit);
var
  I: Integer;
  MinDist, D: Integer;
begin
  U.Target := -1;
  MinDist := MaxInt;
  for I := 1 to 6 do
    if (Buildings[I].Team <> U.Team) and (Buildings[I].Active) then
      if U.PreferBuilding or Buildings[I].IsKing then
      begin
        D := Abs(U.X - Buildings[I].X) + Abs(U.Y - Buildings[I].Y);
        if D < MinDist then
        begin
          MinDist := D;
          U.Target := I;
        end;
      end;
  if U.Target = -1 then
    for I := 1 to NumUnits do
      if (Units[I].Team <> U.Team) and (Units[I].Active) then
      begin
        D := Abs(U.X - Units[I].X) + Abs(U.Y - Units[I].Y);
        if D < MinDist then
        begin
          MinDist := D;
          U.Target := -I;
        end;
      end;
end;

procedure UpdateGame;
var
  I, J: Integer;
  TX, TY: Integer;
begin
  { Elixir gain }
  PlayerElixir := Min(ELIXIR_MAX, PlayerElixir + BASE_ELIXIR_RATE / FPS);
  OppElixir := Min(ELIXIR_MAX, OppElixir + BASE_ELIXIR_RATE / FPS);

  { Update units }
  for I := 1 to NumUnits do
    if Units[I].Active then
    begin
      if Units[I].HP <= 0 then
      begin
        Units[I].Active := False;
        Continue;
      end;
      if Units[I].Cooldown > 0 then Dec(Units[I].Cooldown);
      FindTarget(Units[I]);
      if Units[I].Target > 0 then
      begin
        TX := Buildings[Units[I].Target].X;
        TY := Buildings[Units[I].Target].Y;
        if Abs(Units[I].X - TX) + Abs(Units[I].Y - TY) <= Units[I].Range then
        begin
          if Units[I].Cooldown = 0 then
          begin
            Buildings[Units[I].Target].HP := Buildings[Units[I].Target].HP - Units[I].Dmg;
            Units[I].Cooldown := Round(Units[I].AttackSpeed * FPS);
          end;
        end
        else
        begin
          if Units[I].Team = 'player' then
            Units[I].Y := Units[I].Y - 1
          else
            Units[I].Y := Units[I].Y + 1;
        end;
      end
      else if Units[I].Target < 0 then
      begin
        J := -Units[I].Target;
        TX := Units[J].X;
        TY := Units[J].Y;
        if Abs(Units[I].X - TX) + Abs(Units[I].Y - TY) <= Units[I].Range then
        begin
          if Units[I].Cooldown = 0 then
          begin
            Units[J].HP := Units[J].HP - Units[I].Dmg;
            Units[I].Cooldown := Round(Units[I].AttackSpeed * FPS);
          end;
        end
        else
        begin
          if Units[I].Team = 'player' then
            Units[I].Y := Units[I].Y - 1
          else
            Units[I].Y := Units[I].Y + 1;
        end;
      end
      else
      begin
        if Units[I].Team = 'player' then
          Units[I].Y := Units[I].Y - 1
        else
          Units[I].Y := Units[I].Y + 1;
      end;
      if (Units[I].Y < 1) or (Units[I].Y > ARENA_HEIGHT) then
        Units[I].Active := False;
    end;

  { Update towers }
  for I := 1 to 6 do
    if Buildings[I].Active then
    begin
      if Buildings[I].HP <= 0 then
      begin
        Buildings[I].Active := False;
        Continue;
      end;
      if Buildings[I].Cooldown > 0 then Dec(Buildings[I].Cooldown);
      for J := 1 to NumUnits do
        if (Units[J].Team <> Buildings[I].Team) and (Units[J].Active) then
          if Abs(Units[J].X - Buildings[I].X) + Abs(Units[J].Y - Buildings[I].Y) <= Buildings[I].Range then
            if Buildings[I].Cooldown = 0 then
            begin
              Units[J].HP := Units[J].HP - Buildings[I].Dmg;
              Buildings[I].Cooldown := Round(Buildings[I].AttackSpeed * FPS);
            end;
    end;

  { Check game over }
  if Buildings[3].HP <= 0 then
  begin
    GameOver := True;
    GotoXY(1, ARENA_HEIGHT + 3);
    Write('Opponent Wins!');
  end
  else if Buildings[6].HP <= 0 then
  begin
    GameOver := True;
    GotoXY(1, ARENA_HEIGHT + 3);
    Write('Player Wins!');
  end;

  DrawArena;
end;

procedure AIUpdate;
var
  I: Integer;
begin
  if (Random < 0.1) and (OppElixir >= 2) then
  begin
    I := Random(4) + 1;
    Deploy(AllCards[I], 25, 5, 'opp');
  end;
end;

procedure InitGame;
var
  I: Integer;
begin
  PlayerElixir := 5;
  OppElixir := 5;
  NumUnits := 0;
  GameOver := False;
  GameTime := 180;
  PlayerHandSize := 4;
  for I := 1 to 4 do
    PlayerHand[I] := AllCards[I];
  for I := 1 to 4 do
    PlayerDeck[I] := AllCards[I];
  InitTowers;
end;

begin
  Randomize;
  InitCards;
  InitGame;
  ClrScr;
  while not GameOver do
  begin
    UpdateGame;
    AIUpdate;
    if KeyPressed then
    begin
      case ReadKey of
        '1'..'4':
          begin
            if (Ord(ReadKey) - Ord('0')) <= PlayerHandSize then
              Deploy(PlayerHand[Ord(ReadKey) - Ord('0')], 25, 20, 'player');
          end;
        #27: GameOver := True; { ESC to quit }
      end;
    end;
    Delay(1000 div FPS);
  end;
  GotoXY(1, ARENA_HEIGHT + 4);
  Write('Press any key to exit...');
  ReadKey;
end.