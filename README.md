# wsl-env

Zentrales Repository für projektübergreifende WSL-Konfigurationen.

Beim Start einer WSL-Shell werden zunächst die globalen Einstellungen aus diesem Repository geladen, anschließend die projektspezifischen Einstellungen aus dem jeweils aktiven Projekt.

---

## Konzept

```
WSL-Start
  └─▶ ~/.bashrc
        └─▶ wsl-env/env/wsl/bootstrap.sh
              ├─▶ env/wsl/aliases.sh          ← globale Aliases (dieses Repo)
              └─▶ <projekt>/env/wsl/*.sh      ← projektspezifische Aliases
```

Das aktive Projekt wird in `~/.wsl-project` konfiguriert. Jedes Projekt legt seine WSL-Konfiguration in einem eigenen Verzeichnis `env/wsl/` ab.

---

## Verzeichnisstruktur

```
wsl-env/
└── env/
    └── wsl/
        ├── bootstrap.sh    Loader: lädt globale + projektspezifische Aliases
        └── aliases.sh      Globale, projektunabhängige Aliases und Funktionen
```

Projektspezifische Konfiguration (Beispiel `app-pragma-java`):

```
app-pragma-java/
└── env/
    └── wsl/
        └── aliases.sh      Projektspezifische Aliases
```

---

## Einrichtung auf einem neuen Rechner

### 1. Repositories klonen

```bash
git clone https://github.com/r-uu/wsl-env ~/develop/github/wsl-env
```

Das jeweilige Projekt-Repository daneben klonen, z. B.:

```bash
git clone https://github.com/r-uu/app-pragma-java ~/develop/github/app-pragma-java
```

### 2. `.bashrc` anpassen

Den folgenden Block in `~/.bashrc` eintragen (oder die bestehende Alias-Zeile ersetzen):

```bash
# WSL-Konfiguration: global + aktives Projekt
if [ -f ~/develop/github/wsl-env/env/wsl/bootstrap.sh ]; then
    source ~/develop/github/wsl-env/env/wsl/bootstrap.sh
fi
```

### 3. Aktives Projekt setzen

```bash
echo "/home/<user>/develop/github/app-pragma-java" > ~/.wsl-project
```

Oder nach dem ersten Shell-Start über den Alias:

```bash
ruu-project-set /home/<user>/develop/github/app-pragma-java
```

### 4. Shell neu starten

```bash
exec bash
```

---

## Aktives Projekt wechseln

```bash
# Projekt wechseln und Aliases sofort neu laden
ruu-project-set /home/r-uu/develop/github/app-pragma-java
ruu-project-set /home/r-uu/develop/github/java/main

# Aktuelles Projekt anzeigen
ruu-project-show
```

`ruu-project-set` schreibt den Pfad in `~/.wsl-project` und lädt den Bootstrap neu — kein Shell-Neustart nötig.

---

## Globale Aliases (immer verfügbar)

### Alias-Verwaltung

| Alias / Funktion | Beschreibung |
|---|---|
| `ruu-aliases-reload` | Globale + projektspezifische Aliases neu laden |
| `ruu-aliases-edit` | Globale Aliases bearbeiten (`wsl-env/env/wsl/aliases.sh`) |
| `ruu-aliases-edit-project` | Aliases des aktiven Projekts bearbeiten |

### Projektverwaltung

| Alias / Funktion | Beschreibung |
|---|---|
| `ruu-project-set <pfad>` | Aktives Projekt setzen und Aliases neu laden |
| `ruu-project-show` | Aktives Projekt anzeigen |

### Hilfe & Übersicht

| Alias / Funktion | Beschreibung |
|---|---|
| `ruu-help` | Alle Aliases auflisten (global + aktives Projekt) |
| `ruu-groups` | Alias-Gruppen des aktiven Projekts im Überblick |

### Java & Tools

| Alias | Beschreibung |
|---|---|
| `ruu-java-version` | Java-Version anzeigen |
| `ruu-maven-version` | Maven-Version anzeigen |
| `ruu-docker-version` | Docker-Version anzeigen |
| `ruu-graalvm-version` | GraalVM-Version und Pfad anzeigen |
| `ruu-versions` | Alle Tool-Versionen auf einmal anzeigen |

### IntelliJ IDEA

| Alias / Funktion | Beschreibung |
|---|---|
| `ruu-ij` | IntelliJ IDEA starten (WSL-native via WSLg) |
| `ruu-toolbox` | JetBrains Toolbox starten |

### Shell

| Alias | Beschreibung |
|---|---|
| `ruu-shell-reset` | Shell zurücksetzen (`exec bash`) |
| `ll`, `la`, `l` | Komfort-Aliases für `ls` |

---

## Neues Projekt anbinden

1. Im Projekt-Repository das Verzeichnis `env/wsl/` anlegen:

```bash
mkdir -p /pfad/zum/projekt/env/wsl
```

2. Datei `env/wsl/aliases.sh` erstellen:

```bash
#!/bin/bash
# Projektspezifische WSL-Aliases für <projektname>.
# Geladen von wsl-env/bootstrap.sh wenn ~/.wsl-project auf dieses Repo zeigt.

export MEIN_PROJEKT="/pfad/zum/projekt"

alias mein-alias='cd $MEIN_PROJEKT && mvn package'

echo "✓  <projektname> aliases loaded"
```

3. Projekt als aktiv setzen:

```bash
ruu-project-set /pfad/zum/projekt
```

Der Bootstrap lädt automatisch alle `*.sh`-Dateien aus `<projekt>/env/wsl/`.

---

## Bekannte Projekte mit WSL-Konfiguration

| Projekt | Pfad | Inhalt |
|---|---|---|
| `app-pragma-java` | `env/wsl/aliases.sh` | `ruu-pragma-cd`, `ruu-pragma-win-exe` |
| `java/main` | `env/wsl/aliases.sh` | Maven, Docker, Keycloak, PostgreSQL, Open Liberty |
