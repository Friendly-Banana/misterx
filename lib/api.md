| url    | method | parameter   | data                            |
|--------|--------|-------------|---------------------------------|
| create | GET    |             | lobby code                      |
| join   | POST   | lobby code  | success                         |
| leave  | GET    |             | success                         |
| kick   | POST   | player name | success                         |
| start  | GET    |             | success                         |
| pos    | POST   | position    | success                         |
| player | GET    |             | list of players, maybe filtered |

url always prefixed by /api/

auth/session cookies?
player name + lobby code


**type player**
int id
String name
bool mrX
LatLng pos

**type LatLng**
double latitude
double longitude