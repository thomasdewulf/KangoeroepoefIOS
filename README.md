# Poef app 152e FOS De Kangoeroes - iOS
##Poef app voor iOS. Eindopdracht voor Native Apps II : iOS aan de HoGent

###App starten

Voer 
`pod install` uit 
in de directory waar de app zich bevind om alle nodige dependencies te installeren.

Het is belangrijk op **KangoeroePoef2.xcworkspace** te openen in plaats van KangoeroePoef2.xcodeproj. 


###Wat
De app is gemaakt voor leiding van 152e FOS De Kangoeroes uit Heusden. 
Het doel er van is om de huidige papieren poef deels te vervangen.

Leiding kan inloggen met hun totemnaam. Daarna krijgen ze een lijst te zien met alle dranken die beschikbaar zijn.
Wanneer op de lijst zelf gedrukt wordt, dan krijgen ze een scherm met daarin alle leiding. Per persoon kunnen ze aangeven hoeveel consumpties
de persoon van de gekozen drank gedronken heeft.
Bij het drukken op het 'i' symbool, wordt een detailscherm van de drank weergegeven. Hier is informatie te zien over de drank. Ook het aantal dat al gedronken is door de ingelogde persoon.

###Testen
Inloggen kan met testaccounts gaande van hond0 t.e.m. hond9

###Extra informatie

De app maakt gebruik van een backend geschreven in ASP.NET Core 1.0. Het basisdashboard daarvoor is te bekijken op [poef.thomasdewulf.be](http://poef.thomasdewulf.be)

De app zelf maakt gebruik van volgende frameworks:

- Realm
- SwiftyJSON
- Alamofire
- Reachability

Alle data wordt offline opgeslaan. Het is dus niet vereist om online te zijn om de app te gebruiken.
Ook bestellingen kunnen geplaatst worden zonder online te zijn. Van zodra er terug connectie is, wordt er gesynchroniseerd met de server.
