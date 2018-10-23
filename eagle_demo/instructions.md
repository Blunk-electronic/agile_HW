# Demo Rundown

## Schritt 0

## Schritt 1

### Schritt 1.1 - Blockdiagramm erweitern

- Block für keyboard anlegen
- Mit Kunden reviewen und Bestätigung

### Schritt 1.2 - Keyboard Modul Schematic

- Mit Modul-Template aus Framework starten
- Productfeatures realisieren (Taster und Pull-Up)
- Auf Namensvergabe der Netze achten
- Taster mittels Attr. Funktion dokumentieren
- Development Page mit Verbinder zum Shield hinzufügen
- Masse auf Pin 1 gemäß Guidelines
- Funktion Steckverbinder mittels Attr. dokumentieren


### Schritt 1.3 - Schematic vom Shield aktualisieren

- Seite mit Steckverbinder aus Keyboard Schaltplan kopieren und einfügen
- Debug-LED auf Wunsch der Software hinzunehmen
- Funktion Debug LED dokumentieren
- Routing um neues Signal zum Core ergänzen
- Netchanger erklären


### Schritt 1.4 - Layout Keyboard Modul erstellen

- Ausgangspunkt ist wieder das Template (Passmarken, Bohrungen, etc.)
- Platzierung Bauteile
- Silkscreen mit Funktionsdokumentation der interaktiven Bauteile 
- Autorouter
- DRC

### Schritt 1.5 - Layout Shield aktualisieren

- Debug Leuchtdiode und Stecker zum Keyboard modul platzieren
- Dokumentation der Funktion in Bestückungsdruck übernehmen
- Autorouter 
- DRC

## Schritt 2 Produktdesign ableiten

### Schritt 2.1 Merg Schaltplan Produkt aus Rig Schaltplänen 

- Import Core
- Import Shield
- Import Keyboard
- Import LED
- Development Seiten löschen

### Schritt 2.2 Reduce Routing

- Netze an Netchangern von 1 nach 2 übernehmen
- Routingseite löschen
- Produktlayout
- Packages ändern
