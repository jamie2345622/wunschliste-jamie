# Jamies Wunschliste


Die Wunschliste ist eine statische, mobil nutzbare Website. Wünsche und Klickstatistiken werden in Supabase gespeichert; der Adminbereich liegt unter `/kontrolle/`.


## Einmalige Einrichtung


1. `supabase/schema.sql` im SQL Editor des verbundenen Supabase-Projekts ausführen. Das legt Tabellen, Zugriffregeln (RLS) und die drei vorhandenen Wünsche an.
2. In Supabase unter **Authentication → Users** die Einladung für `jamie.trading.9@gmail.com` annehmen und über `/kontrolle/` ein starkes Passwort festlegen.
3. In `supabase-config.js` stehen die Projekt-URL und der öffentliche Publishable Key. Dieser Schlüssel darf im Browser verwendet werden, weil der Zugriff durch die RLS-Regeln beschränkt ist. Niemals einen Secret- oder `service_role`-Key in die Website eintragen.
4. In Supabase unter **Authentication → URL Configuration** die Site URL auf `https://jamie2345622.github.io/wunschliste-jamie/kontrolle/` setzen und die GitHub-Pages-Adresse als Redirect URL erlauben.
5. Im GitHub-Repository unter **Settings → Pages** GitHub Pages für den Branch `main` und den Ordner `/ (root)` aktivieren.


Danach ist die öffentliche Seite unter `https://jamie2345622.github.io/wunschliste-jamie/` und die Verwaltung unter `https://jamie2345622.github.io/wunschliste-jamie/kontrolle/` erreichbar.


Im Adminformular kann `jamie` als Benutzername verwendet werden; die Anmeldung wird intern auf die oben genannte E-Mail-Adresse abgebildet. Supabase Auth prüft das Passwort. Die öffentliche Seite speichert pro Klick nur Wunsch-ID, Zeitpunkt und groben Gerätetyp (Handy, Tablet oder Computer), keine IP-Adresse oder individuelle Geräte-ID. Damit lässt sich nicht feststellen, welche konkrete Person oder welches konkrete Gerät geklickt hat.
