/* ------  GAMEMODE INCLUDES ------- */
#include <open.mp>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <foreach>
#include <a_mysql>
#include <string_new>
#include <crashdetect>
#include <compat>

/* ------  MAPPING INCLUDES ------- */
#include "Maps/RemoveBuildings.pwn"
#include "Maps/Maps.pwn"

/* ------ SERVER STATIC INFORMATION ------- */
new 		MySQL:connection 	= MYSQL_INVALID_HANDLE;
#define 	SERVER_NAME 		"Open Roleplay - New Release Open.mp"
#define 	SERVER_VERSION 		"0.1.5b"
#define     SERVER_MODE         "Roleplay"
#define 	SERVER_MAPNAME  	"Los Santos"

#define 	SQL_SERVER 			"localhost"
#define 	SQL_USER 			"root"
#define 	SQL_PASSWORD 		""
#define 	SQL_DB 				"openroleplay"

#define 	PI 						3.14159265358979323846
	
#define 	MAX_DOORS       		200
#define 	MAX_HOUSES       		200
#define     MAX_FACTIONS            20
#define     MAX_BUSINESSES          200
#define     MAX_PLAYER_HOUSES       1
#define     MAX_PLAYER_BUSINESSES   1
#define     MAX_PLAYER_HOTELS       1
#define     MAX_PLAYER_HP_LEVEL     10
#define     MAX_CRIMES              5000
#define     MAX_PHONE_NUMBERS       5000
#define     MAX_BILLS               5000
#define     MAX_LOANS               500

#define 	SERVER_INT_WEATHER 	"1"
#define 	SERVER_INT_TIME 	"12"
#define     SERVER_BANK_INTREST "5%"

/* ------ GENERAL INFORMATION ------- */
#define 	COLOR_WHITE  		0xFFFFFFFF
#define		COLOR_GREY			0xD2D2D2FF
#define 	COLOR_RED   		0xFF323200
#define 	COLOR_LIGHTRED 		0xF08080FF
#define 	COLOR_GREEN 		0x56E219FF
#define		COLOR_LIGHTGREEN	0x99D87DFF
#define 	COLOR_ORANGE 		0xFFA500AA
#define 	COLOR_PINK 			0xFA2C71AA
#define 	COLOR_YELLOW 		0xF2F746AA
#define 	COLOR_LIME 			0x72F70CAA
#define 	COLOR_PURPLE 		0xC2A2DAAA
#define 	COLOR_FADE1 		0xFFFFFFFF
#define 	COLOR_FADE2 		0xC8C8C8C8
#define 	COLOR_FADE3 		0xAAAAAAAA
#define 	COLOR_FADE4 		0x8C8C8C8C
#define 	COLOR_FADE5 		0x6E6E6E6E
#define 	COLOR_AQUABLUE  	0x7FFFD4FF
#define 	COLOR_LIGHTBLUE		0x57B7DCFF
#define 	COLOR_SEAGREEN 		0x2E8B57FF
#define 	COLOR_LIGHTSEAGREEN 0x20B2AAFF
#define 	COLOR_CORAL 		0xFF7F50FF

#define SendPlayerServerMessage(%0,%1) \
	SendClientMessage(%0, COLOR_ORANGE, "[SERVER]:{FFFFFF} "%1)

#define SendPlayerErrorMessage(%0,%1) \
	SendClientMessage(%0, COLOR_PINK, "[ERROR]:{FFFFFF} "%1)
	
#define SendGlobalServerMessage(%1) \
	SendClientMessageToAll(COLOR_ORANGE, "[GLOBAL SERVER]:{FFFFFF} "%1)
	
#define SendGlobalErrorMessage(%1) \
	SendClientMessageToAll(COLOR_PINK, "[GLOBAL ERROR]:{FFFFFF} "%1)
	
#define HOLDING(%0) \
((newkeys & (%0)) == (%0))

// SERVER DIALOG DEFINES

#define 	DIALOG_LOGIN				1
#define 	DIALOG_REGISTER				2
#define 	DIALOG_REGISTER_EMAIL   	3
#define 	DIALOG_REGISTER_AGE     	4
#define 	DIALOG_REGISTER_SEX     	5
#define 	DIALOG_REGISTER_BP      	6
#define 	DIALOG_REGISTER_END     	7

#define		DIALOG_BAN_MSG				9

#define 	DIALOG_GUIDE_LIST     		10
#define 	DIALOG_GUIDE_JOBS     		11
#define 	DIALOG_GUIDE_FACTIONS  		12
#define 	DIALOG_GUIDE_COMMANDS  		13
#define 	DIALOG_GUIDE_VEHICLES  		14
#define 	DIALOG_GUIDE_HOUSES    		15
#define 	DIALOG_GUIDE_ADMINS    		16

#define     DIALOG_COMMANDS_MAIN    	20
#define     DIALOG_COMMANDS_GENERAL 	21
#define     DIALOG_COMMANDS_FACTION 	22
#define     DIALOG_COMMANDS_HOUSE   	23
#define     DIALOG_COMMANDS_BIZZ    	24
#define     DIALOG_COMMANDS_JOB	    	25
#define     DIALOG_COMMANDS_ADMIN   	26

#define     DIALOG_PLAYER_STATS     	40
#define     DIALOG_PLAYER_STATS_MORE   	41
#define     DIALOG_PLAYER_SKINS         42
#define     DIALOG_PLAYER_POCKETS       43
#define		DIALOG_PLAYER_SHOP_SKIN		44

#define     DIALOG_BANK_REGISTER    	50
#define     DIALOG_BANK_LOGIN       	51
#define     DIALOG_BANK_MENU     		52
#define     DIALOG_BANK_ACCOUNT     	53
#define     DIALOG_BANK_BUSINESS    	54
#define     DIALOG_BANK_STOCK	    	55
#define     DIALOG_BANK_CLOSE	    	56
#define		DIALOG_BANK_AWITHDRAW   	57
#define     DIALOG_BANK_ADEPOSIT    	58

#define     DIALOG_MDC_MENU         	60
#define     DIALOG_MDC_PLAYER_SEARCH 	61
#define     DIALOG_MDC_PLAYER_RESULTS   62
#define     DIALOG_MDC_VEHICLE_SEARCH   63
#define     DIALOG_MDC_VEHICLE_RESULTS  64

#define     DIALOG_LSPD_SEARCH          70
#define     DIALOG_LSPD_SEARCH_RESULTS  71

#define     DIALOG_SHOP_ROB_KNIFE       94
#define     DIALOG_SHOP_ROB_9MM		    95
#define     DIALOG_SHOP_ROB_SHOTGUN     96
#define     DIALOG_SHOP_ROB_AK-47	    97
#define     DIALOG_SHOP_ROB_RIFLE	    98
#define     DIALOG_SHOP_ROB_SRIFLE	    99

#define     DIALOG_PHONEBOOK_NUMBERS    100

#define     DIALOG_GPS_MAIN             110
#define     DIALOG_GPS_TOP              111
#define     DIALOG_GPS_FACTIONS         112
#define     DIALOG_GPS_JOBS             113

#define     DIALOG_DEALERSHIP_1_MAIN    120
#define     DIALOG_DEALERSHIP_1_SELECT  121
#define     DIALOG_DEALERSHIP_2_MAIN    122
#define     DIALOG_DEALERSHIP_2_SELECT  123
#define     DIALOG_DEALERSHIP_3_MAIN    124
#define     DIALOG_DEALERSHIP_3_SELECT  125

#define     DIALOG_BANK_FAC_LOGIN       130
#define     DIALOG_BANK_FAC_LOANS       131
#define     DIALOG_BANK_FAC_LOAN_INFO   132
#define     DIALOG_BANK_FAC_LOAN_STAT   133
#define     DIALOG_BANK_FAC_APPROVAL    134
#define     DIALOG_BANK_FAC_REJECTION   135
#define     DIALOG_BANK_FAC_NOLOANS     136
#define     DIALOG_BANK_FAC_END         137

#define     DIALOG_BANK_LOAN_AMOUNT     140
#define     DIALOG_BANK_LOAN_REASON     141
#define     DIALOG_BANK_LOAN_SUBM       142
#define     DIALOG_BANK_VIEW_LOANS      143

#define     DIALOG_JOB_VIEW             150
#define		DIALOG_PIZZA_END			151

#define     DIALOG_LICENSE_VIEW         160

#define     DIALOG_SHOP_TYPE_ONE        200
#define     DIALOG_SHOP_TYPE_TWO        201
#define     DIALOG_SHOP_TYPE_THREE      202
#define     DIALOG_SHOP_TYPE_FOUR      	203
#define     DIALOG_SHOP_TYPE_FIVE      	204
#define     DIALOG_SHOP_TYPE_SIX      	205
#define     DIALOG_SHOP_TYPE_SEVEN      206
#define     DIALOG_SHOP_TYPE_EIGHT      207
#define     DIALOG_SHOP_TYPE_NINE      	208
#define     DIALOG_SHOP_3_MOB           209
#define     DIALOG_SHOP_3_SIM           210
#define 	DIALOG_SHOP_7_WEAPONS  		211
#define 	DIALOG_SHOP_7_EXTRAS  		212
#define		DIALOG_SHOP_3_HOUSE			213

#define		DIALOG_SPRAY_PAINT			250
#define		DIALOG_SPRAY_CONFIRM		251

#define		DIALOG_DRUG_SELECTION		300

// SERVER DEFINES
#define 	TRUCK_VEHICLE_MODELS_COUNT 	15
#define 	MOTORCYCLE_MODELS_COUNT 	9
#define 	AIRCRAFT_MODELS_COUNT 		18
#define 	BOAT_MODELS_COUNT 			10

#define 	SKIN_COUNT 					(sizeof(cheapSkins) / sizeof(cheapSkins[0]))

new truckVehicleModels[TRUCK_VEHICLE_MODELS_COUNT] = {403, 406, 407, 408, 414, 433, 443, 455, 456, 514, 515, 524, 544, 578};
new motorcycleModels[MOTORCYCLE_MODELS_COUNT] = {461, 462, 463, 468, 471, 521, 522, 523, 581};
new aircraftModels[AIRCRAFT_MODELS_COUNT] = {593, 592, 577, 553, 520, 519, 513, 512, 511, 497, 488, 487, 476, 469, 460, 447, 425, 417};
new boatModels[BOAT_MODELS_COUNT] = {430, 446, 452, 453, 454, 472, 473, 484, 493, 595};
new cheapSkins[125] = {
    3, 4, 5, 6, 7, 8, 10, 13, 
    14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 
    25, 26, 28, 29, 30, 31, 32, 33, 34, 35, 
    39, 41, 42, 44, 45, 47, 48, 49, 53, 54, 
    56, 58, 60, 63, 64, 65, 66, 67, 69, 72, 
    73, 75, 77, 78, 79, 82, 83, 84, 85, 86, 
    87, 88, 89, 93, 95, 97, 100, 101, 102, 103, 
    104, 105, 106, 107, 108, 19, 110, 114, 115, 
    116, 121, 122, 129, 130, 131, 132, 133, 134, 
    135, 136, 137, 142, 143, 144, 149, 151, 152, 
    156, 157, 158, 159, 160, 161, 162, 168, 170, 
    173, 174, 175, 176, 177, 178, 179, 180, 181, 
    182, 190, 191, 192, 193, 293, 292, 291, 289, 
    271, 270, 269
};

enum playerInfo
{
	Account_ID,
	Account_Email[129],
	Account_IP,
    Character_Name[MAX_PLAYER_NAME],
    Character_Password[129],
    Character_Registered,
    Character_Age,
    Character_Sex[129],
    Character_Birthplace[129],
    Character_Skin_1,
    Character_Skin_2,
    Character_Skin_3,
    Character_Skin_Logout,
	Character_Last_Login,
	Character_Minutes,
	Character_Ban,
	Float:Character_Health,
	Float:Character_Armor,
	Character_Job,
    Character_Faction,
    Character_Faction_Rank,
    Character_Faction_Join_Request,
    Character_Faction_Ban,
	Character_Money,
	Character_Coins,
	Character_Bank_Account,
	Character_Bank_Money,
	Character_Bank_Pin[129],
	Character_Bank_Loan,
	Character_VIP,
    Float:Character_Pos_X,
    Float:Character_Pos_Y,
    Float:Character_Pos_Z,
    Float:Character_Pos_Angle,
    Character_Interior_ID,
    Character_Virtual_World,
    Character_House_ID,
    Character_Total_Houses,
    Character_Owns_Faction,
    Character_Business_ID,
    Character_Total_Businesses,
	Character_Level,
	Character_Level_Exp,
	Character_Ticket_Amount,
	Character_Total_Ticket_Amount,
	Character_Jail,
	Character_Jail_Time,
	Character_Jail_Reason[50],
	Character_Last_Crime[50],
	Moderator_Level,
	Helper_Level,
	Admin_Level,
	Admin_Level_Exp,
	Admin_Jail,
	Admin_Jail_Time,
	Admin_Jail_Reason[50],
	Weapon_Slot_1,
	Weapon_Slot_2,
	Weapon_Slot_3,
	Weapon_Slot_4,
	Weapon_Slot_5,
	Weapon_Slot_6,
	Ammo_Slot_1,
	Ammo_Slot_2,
	Ammo_Slot_3,
	Ammo_Slot_4,
	Ammo_Slot_5,
	Ammo_Slot_6,
	Character_Radio,
	Character_License_Car,
	Character_License_Truck,
	Character_License_Motorcycle,
	Character_License_Boat,
	Character_License_Flying,
	Character_License_Firearms,
	Character_Drug_Cocaine,
	Character_Drug_Heroin,
	Character_Has_Rope,
	Character_Has_Fuelcan,
	Character_Has_Lockpick,
	Character_Has_Drugs,
	Character_Has_Food,
	Character_Has_Drinks,
	Character_Has_Alcohol,
	Character_Has_Device,
	Character_Has_Phone,
	Character_Has_Mask,
	Character_Phonenumber,
	Character_Has_SimCard,
	Character_Hotel_ID,
	Float:Hotel_Character_Pos_X,
    Float:Hotel_Character_Pos_Y,
    Float:Hotel_Character_Pos_Z,
    Float:Hotel_Character_Pos_Angle,
    Hotel_Character_Interior_ID,
    Hotel_Character_Virtual_World,
    Character_Total_Vehicles
};
new PlayerData[MAX_PLAYERS][playerInfo];

enum playermdcInfo
{
	MDC_Crime_Report_ID,
	MDC_Crime_Character_Name[50],
	MDC_Crime_Desc[150],
	MDC_Crime_Alert
};
new PlayerMDCData[MAX_CRIMES][playermdcInfo];

enum loanInfo
{
	Loan_ID,
	Loan_Name[50],
	Loan_Amount,
	Loan_Reason[50],
	Loan_Status
};
new LoanData[MAX_LOANS][loanInfo];

enum factionInfo
{
	Faction_ID,
	Faction_Name[20],
	Faction_Rank_1[20],
	Faction_Rank_2[20],
	Faction_Rank_3[20],
	Faction_Rank_4[20],
	Faction_Rank_5[20],
	Faction_Rank_6[20],
	Faction_Join_Requests,
	Float:Faction_Icon_X,
	Float:Faction_Icon_Y,
	Float:Faction_Icon_Z,
	Faction_Pickup_ID_Outside,
	Faction_Owner[50],
	Faction_Price_Money,
	Faction_Price_Coins,
	Faction_Sold,
	Faction_Money
};
new FactionData[MAX_FACTIONS][factionInfo];

enum businessInfo
{
	Business_ID,
	Business_Price_Money,
	Business_Price_Coins,
	Business_Sold,
	Business_Owner[50],
	Business_Name[50],
	Business_Type,
	Business_Alarm,
	Business_Robbed,
	Business_Robbed_Value,
	Business_Pickup_ID_Outside,
	Business_Pickup_ID_Inside,
	Float:Business_Inside_X,
	Float:Business_Inside_Y,
	Float:Business_Inside_Z,
	Float:Business_Inside_A,
	Business_Inside_Interior,
	Business_Inside_VW,
	Float:Business_Outside_X,
	Float:Business_Outside_Y,
	Float:Business_Outside_Z,
	Float:Business_Outside_A,
	Business_Outside_Interior,
	Business_Outside_VW,
	Float:Business_BuyPoint_X,
	Float:Business_BuyPoint_Y,
	Float:Business_BuyPoint_Z
};
new BusinessData[MAX_BUSINESSES][businessInfo];

enum houseInfo
{
	House_ID,
	House_Price_Money,
	House_Price_Coins,
	House_Sold,
	House_Owner[50],
	House_Address[150],
	House_Alarm,
	House_Lock,
	House_Robbed,
	House_Robbed_Value,
	House_Pickup_ID_Outside,
	House_Pickup_ID_Inside,
	Float:House_Spawn_X,
	Float:House_Spawn_Y,
	Float:House_Spawn_Z,
	Float:House_Spawn_A,
	House_Spawn_Interior,
	House_Spawn_VW,
	Float:House_Inside_X,
	Float:House_Inside_Y,
	Float:House_Inside_Z,
	Float:House_Inside_A,
	House_Inside_Interior,
	House_Inside_VW,
	Float:House_Outside_X,
	Float:House_Outside_Y,
	Float:House_Outside_Z,
	Float:House_Outside_A,
	House_Outside_Interior,
	House_Outside_VW,
	House_Preset_Type,
	House_Alarm_Active,
	House_Lock_Active
};
new HouseData[MAX_HOUSES][houseInfo];

enum doorInfo
{
	Door_ID,
	Door_Faction,
	Door_Description[50],
	Door_Pickup_ID_Outside,
	Door_Pickup_ID_Inside,
	Float:Door_Inside_X,
	Float:Door_Inside_Y,
	Float:Door_Inside_Z,
	Float:Door_Inside_A,
	Door_Inside_Interior,
	Door_Inside_VW,
	Float:Door_Outside_X,
	Float:Door_Outside_Y,
	Float:Door_Outside_Z,
	Float:Door_Outside_A,
	Door_Outside_Interior,
	Door_Outside_VW
};
new DoorData[MAX_DOORS][doorInfo];

enum vehicleInfo
{
	Vehicle_ID,
	Vehicle_Faction,
	Vehicle_Job,
	Vehicle_Owner[50],
	Vehicle_Used,
	Vehicle_Model,
	Vehicle_Color_1,
	Vehicle_Color_2,
	Float:Vehicle_Spawn_X,
	Float:Vehicle_Spawn_Y,
	Float:Vehicle_Spawn_Z,
	Float:Vehicle_Spawn_A,
	Vehicle_Spawn_Interior,
	Vehicle_Spawn_VW,
	Vehicle_Lock,
	Vehicle_Alarm,
	Vehicle_GPS,
	Vehicle_License_Plate[10],
	Vehicle_Fuel,
	Vehicle_Type,
};
new VehicleData[MAX_VEHICLES][vehicleInfo];

// GENERAL SCRIPT REFERENCES.0

new VehicleModelNames[][] = {
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper", "Fire Truck", "Trashmaster", "Stretch", "Manana",
	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
	"Mr. Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife",
	"Articulated Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo",
	"Seasparrow", "Pizzaboy", "Tram", "Articulated Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
	"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito",
	"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring Racer",
	"Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
	"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker",
	"Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Towtruck", "Fortune",
	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Brown Streak",
	"Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Fire Truck Ladder", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
	"Utility Van", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance",
	"RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
	"Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Tanker Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog",
	"Club", "Freight Box", "Articulated Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "Police (LS)", "Police (SF)",
	"Police (LV)", "Ranger", "Picador", "S.W.A.T.", "Alpha", "Phoenix", "Glendale (Damaged)", "Sadler (Damaged)", "Baggage Box A",
	"Baggage Box B", "Tug Stairs", "Boxville", "Farm Trailer", "Utility Trailer"
};

new RandomMessages[][] = {
    "[TIP]: Do you want to apply for a faction? Do it ingame with /joinfaction",
    "[TIP]: Where did your vehicle go? Check the local junk yard near All Saints",
    "[TIP]: To view all current server commands, use /commands",
    "[TIP]: Did you know that you can rob the bank? That is, if someone hasn't already",
	"[TIP]: Did someone do something wrong? Use /report to report them to the staff team",
    "[TIP]: Do you need help? Use /helpme for further assistance",
    "[TIP]: Can't see door information? Walk into the icon to see the information",
    "[TIP]: If you become a VIP player, there is a safe location from all other players"
};

new Float:InfoPickups[][] =
{
	{1439.5317,-2281.4648,13.5469}, // /TUTORIALICON
	{1418.1593,-2311.6946,13.9298}, // /RENTCAR ICON
	{-1876.2999,50.1774,1055.1891}, // /GUIDE ICON
	{254.2574,76.7777,1003.6406}, // /DUTY LSPD ICON
	{2051.0803,-1842.6533,13.5633}, // /DUTY MECHANIC ICON
	{2054.3008,-1842.2689,13.5633}, // /TOOLS ICON
	{1783.4768,-1694.1383,16.7503}, // /FIREEX LSFD ICON
	{1780.0322,-1693.6436,16.7503}, // /DUTY LSFD ICON
	{-1098.3324,1995.3967,-58.9141}, // /DUTY LSMC ICON
	{1808.8501,-1898.7998,13.5790}, // /JOB - TAXI
	{254.4943,85.0860,1002.4453}, // Arrest Point
	{2164.5356,1600.1710,999.9771}, // Bank Desk Location
	{2409.5278,-1426.0397,23.9829}, // Recycle Point
	{1544.5784,-1670.9464,13.5587}, // LSPD Join Point
	{1755.8239,-1720.1548,13.3870}, // LSFD Join Point
	{1178.3011,-1328.0625,14.1133}, // LSMC Join Point
	{1511.0210,-1464.6028,9.5000}, // TOWING DUTY POINT
	{1376.2294,-1423.9144,13.5768}, // Driving School Icon
	{618.3365,-76.9667,997.9922}, // Dudefix Duty Point
	{2102.2109,-1789.1084,13.5547}, // Pizza Delivery Job
	{992.1449,-1454.0868,13.5469}, // Electrician Job
	{2201.1582,-1974.1382,13.5576} // Garbage Job
};

new Float:PoliceJailSpawns[3][3] =
{
	{264.4284,86.5077,1001.0391}, // Jail Slot 1
	{264.6077,86.6181,1001.0391}, // Jail Slot 2
	{264.6636,77.7305,1001.0391} // Jail Slot 3
};

new Float:ElectricianJob1[7][3] = // Light repairs
{
	{1043.7421,-1314.6869,13.5469},
	{1072.5300,-1135.9929,23.6567}, 
	{1170.9996,-1154.6633,23.8281},
	{1349.3269,-1131.0897,23.8281},
	{1337.2238,-1384.0043,13.6867}, 
	{1468.9659,-1446.8481,13.5469},
	{1442.4681,-1738.3464,13.5469}
};

new Float:DrugDealerActorLocations[3][4] =
{
	{1405.2183,-1299.1311,13.5445,246.3366},
	{1115.1992,-1101.5356,25.7899,322.1172},
	{759.2241,-1816.9330,13.0234,33.8473}
};

new Float:DealershipOneParks[6][4] =
{
	{962.9628,-1542.8658,13.3569,269.9742}, 
	{974.2844,-1542.8656,13.3593,269.9742}, 
	{986.2587,-1542.8741,13.3619,269.9742},
	{983.9670,-1523.7238,13.3191,179.7765}, 
	{979.8921,-1523.3783,13.3183,179.7765}, 
	{975.6407,-1523.6489,13.3189,179.7765} 
};

new Float:DealershipTwoParks[3][4] =
{
	{957.2658,-1758.7263,13.3788,171.8536},
	{952.3511,-1758.1240,13.3785,173.8608},
	{947.1748,-1757.3601,13.3786,171.9380}
};

new Float:DealershipThreeParks[3][4] =
{
	{1024.6239,-1742.4526,13.5452,269.5414},
	{1025.1648,-1747.8467,13.5451,269.5414},
	{1024.4756,-1744.8911,13.5408,269.5414}
};

new Float:BankDeskLocations[][] =
{
    {2164.5356,1600.1710,999.9771}
};

new Float:LSPDBackupPosition[3];

new bool:GPSOn[MAX_PLAYERS];
new bool:LSFDGateLeftOpen;
new bool:LSFDGateRightOpen;
new bool:LSFDGateBackOpen;
new bool:LSFDGarageDoorOpen;
new bool:LSFDTopDoorOpen;
new bool:MechanicFrontGateOpen;
new bool:BankDoorOpen;
new bool:TowGateOpen;
new bool:JunkYardGateOpen;

new bool:IsPlayerUsingClient[MAX_PLAYERS];

new SERVER_MESSAGE_COUNT;
new SERVER_HOUR;
new SERVER_MINUTE;
new SERVER_SECOND;
new GLOBALCHAT;
new VEHICLEPROCESS;

new HOUSE_ALARM_ID;

new SQL_DOOR_NEXTID;
new SQL_HOUSE_NEXTID;
new SQL_FACTION_NEXTID;
new SQL_BUSINESS_NEXTID;
new SQL_BUSINESS_ID;
new SQL_PHONENUMBER_USED;
new SQL_PHONENUMBER_GENERATED;
new SQL_LOAN_ID[MAX_PLAYERS][MAX_LOANS];
new SQL_LOAN_NAME[MAX_PLAYERS][MAX_LOANS];
new SQL_LOAN_AMOUNT[MAX_PLAYERS][MAX_LOANS];

new SelectedLoanID[MAX_PLAYERS];
new SelectedLoanName[MAX_PLAYERS][50];
new SelectedLoanAmount[MAX_PLAYERS];

new LSPDJobTimer;
new LSPDJobTimerExp;
new LSFDJobTimer;
new LSFDJobTimerExp;
new MechanicJobTimer;
new MechanicJobTimerExp;
new DudefixJobTimer;
new DudefixJobTimerExp;
new BankRobberyTimer;
new BankRobberyTimerExp;
new LSPDJobHouseInspection;
new LSPDJobHouseInspectionAccepted;
new LSFDJobHouseFire;
new LSFDJobHouseFireAccepted;
new LSFDJobHouseFireID;
new LSFDJobHouseFireHealth;
new MechanicJob;
new MechanicJobAccepted;
new MechanicJobID;
new MechanicJobHealth;
new DudefixJob;
new DudefixJobID;
new DudefixJobAccepted;
new DudefixJobCompleted;
new TornadoTimer;
new DrugTimer;
new DrugActor;
new DrugActorAmountHeld;

new HasPlayerTakenDrugs[MAX_PLAYERS];
new HasPlayerBakedDrugs[MAX_PLAYERS];
new DrivingCarPlayer[MAX_PLAYERS];
new DrivingCarCount[MAX_PLAYERS];
new DrivingTruckPlayer[MAX_PLAYERS];
new DrivingTruckCount[MAX_PLAYERS];
new DrivingBikePlayer[MAX_PLAYERS];
new DrivingBikeCount[MAX_PLAYERS];
new TruckJobMoneyStarted;
new TruckJobMoneyPlayer[MAX_PLAYERS];
new TruckJobParcelPlayer[MAX_PLAYERS];
new TruckJobParcelCount[MAX_PLAYERS];
new PizzaJobDeliveryPlayer[MAX_PLAYERS];
new PizzaJobDeliveryCount[MAX_PLAYERS];
new GarbageJobPlayer[MAX_PLAYERS];
new GarbageJobCount[MAX_PLAYERS];
new GarbageJobPosition[MAX_PLAYERS];
new ElectricianLightJobPlayer[MAX_PLAYERS];
new ElectricianLightJobCount[MAX_PLAYERS];
new MechanicJobPlayer[MAX_PLAYERS];
new DudefixJobPlayer[MAX_PLAYERS];
new LSFDJobHouseFirePlayer[MAX_PLAYERS];
new LSPDJobHouseInpPlayer[MAX_PLAYERS];
new BackupCaller[MAX_PLAYER_NAME];
new IsPlayerLogged[MAX_PLAYERS];
new IsPlayerInHelpMeCooldown[MAX_PLAYERS];
new IsPlayerSpectating[MAX_PLAYERS];
new IsPlayerWaitingHospital[MAX_PLAYERS];
new IsPlayerStealingCar[MAX_PLAYERS];
new IsPlayerStealingCarID[MAX_PLAYERS];
new IsPlayerRentingCar[MAX_PLAYERS];
new IsPlayerMuted[MAX_PLAYERS];
new IsPlayerInjured[MAX_PLAYERS];
new IsPlayerDead[MAX_PLAYERS];
new IsPlayerInHospital[MAX_PLAYERS];
new IsPlayerWeaponBanned[MAX_PLAYERS];
new IsPlayerOnDuty[MAX_PLAYERS];
new IsPlayerTased[MAX_PLAYERS];
new IsPlayerCuffed[MAX_PLAYERS];
new IsPlayerTied[MAX_PLAYERS];
new IsPlayerDragged[MAX_PLAYERS];
new IsNewVehicleType[MAX_PLAYERS];
new MechanicFuelAmount[MAX_PLAYERS];
new MechanicToolAmount[MAX_PLAYERS];
new WhoIsDragging[MAX_PLAYERS];
new WhoHasBeenSearched[MAX_PLAYERS];
new WhoIsCalling[MAX_PLAYERS];
new HasPlayerGotShovel[MAX_PLAYERS];
new HasPlayerToggledHelpMe[MAX_PLAYERS];
new HasPlayerFirstSpawned[MAX_PLAYERS];
new HasPlayerBrokenIntoBank[MAX_PLAYERS];
new HasPlayerRobbedBank[MAX_PLAYERS];
new HasPlayerRobbedAmmunation[MAX_PLAYERS];
new HasPlayerRobbedAmmunationPoint[MAX_PLAYERS];
new HasPlayerConfirmedVehicleID[MAX_PLAYERS];
new HasCallBeenPickedUp[MAX_PLAYERS];
new HasPlayerMadeACall[MAX_PLAYERS];
new HasPlayerToggledOffDirectory[MAX_PLAYERS];
new HasPlayerMadeAnEmergencyCall[MAX_PLAYERS];
new EmergencyCallTypeRequired[MAX_PLAYERS];
new EmergencyCallTypeReason[MAX_PLAYERS];
new HasPlayerMadeRequestCall[MAX_PLAYERS];
new RequestCallType[MAX_PLAYERS];
new RequestCallReason[MAX_PLAYERS];
new CanPlayerBuyVehicle[MAX_PLAYERS];
new PlayerAtDoorID[MAX_PLAYERS];
new PlayerAtHouseID[MAX_PLAYERS];
new PlayerAtFactionID[MAX_PLAYERS];
new PlayerAtBusinessID[MAX_PLAYERS];
new PlayerAtBusinessBuyPointID[MAX_PLAYERS];
new VehicleModelPurchasing[MAX_PLAYERS];
new ApplicationLoanAmount[MAX_PLAYERS];
new IsPlayerInViewState_Binco[MAX_PLAYERS];
new Binco_Current_Outfit[MAX_PLAYERS];
new Binco_New_Outfit[MAX_PLAYERS];
new Binco_Current_VW[MAX_PLAYERS];
new HasPlayerChangedVehicleColour[MAX_PLAYERS];
new HasPlayerEnteredSprayUnit[MAX_PLAYERS];
new HasPlayerRequestAssistance[MAX_PLAYERS];
new Float:SpectateX[MAX_PLAYERS];
new Float:SpectateY[MAX_PLAYERS];
new Float:SpectateZ[MAX_PLAYERS];
new BanName[MAX_PLAYERS][50];
new HasPlayerUsedMask[MAX_PLAYERS];
new FoundPlayerHouseID[MAX_PLAYERS];
new DealershipType[MAX_PLAYERS];
new HasGPSBeenDisabled[MAX_PLAYERS];
new PlayerDefaultPayment[MAX_PLAYERS];

new vcreatemodel[MAX_PLAYERS];
new vcreatec1[MAX_PLAYERS];
new vcreatec2[MAX_PLAYERS];

new Text3D:textLabelID[MAX_PLAYERS];

new Vehicle_Flash[MAX_VEHICLES];

new currentSkinIndex = 0;

new LSFDGateLeft;
new LSFDGateRight;
new LSFDGateBack;
new LSFDGarageDoor;
new LSFDTopDoor;
new MechanicFrontGate;
new BankDoor;
new TowGate;
new JunkYardGate;
new PaintSprayDoor;

new LSFDJobHouseFireObject;
new LSFDJobHouseSmokeObject;

new DudeFixObjectOne;
new DudeFixObjectTwo;
new DudeFixObjectThree;
new DudeFixObjectFour;
new DudeFixObjectFive;

new GarbageObject[MAX_PLAYERS];

new TornadoObject1;
new TornadoObject2;
new TornadoObject3;
new TornadoObject4;
new TornadoObject5;
new TornadoObject6;


// TEXTDRAW REFERNCES
new Text:Time;

new PlayerText:LoginTextdraw1;
new PlayerText:LoginTextdraw2;
new PlayerText:LoginTextdraw3;
new PlayerText:LoginTextdraw4;
new PlayerText:LoginTextdraw5;
new PlayerText:LoginTextdraw6;
new PlayerText:Notification_Textdraw;
new PlayerText:Store_Textdraw;
new PlayerText:SpeedBoxFuelAmount;
new PlayerText:SpeedBoxFuelTitle;
new PlayerText:SpeedBoxSpeedTitle;
new PlayerText:SpeedBoxSpeedAmount;

// SERVER TIMERS
new Notification_Timer[MAX_PLAYERS];
new Minute_Timer[MAX_PLAYERS];
new DoorEntry_Timer[MAX_PLAYERS];
new Drag_Timer[MAX_PLAYERS];
new Backup_Timer[MAX_PLAYERS];
new Fuel_Timer[MAX_PLAYERS];
new Repair_Timer[MAX_PLAYERS];
new Vehicle_Timer[MAX_PLAYERS];
new Refuel_Timer[MAX_PLAYERS];
new Hospital_Timer[MAX_PLAYERS];
new Hotwire_Timer[MAX_PLAYERS];
new Cooldown_Timer[MAX_PLAYERS];
new CrackDealer_Timer[MAX_PLAYERS];
new DrugUseCooldown_Timer[MAX_PLAYERS];
new DrugBaking_Timer[MAX_PLAYERS];
new VehicleFlash_Timer[MAX_VEHICLES];
new Assistance_Timer[MAX_PLAYERS];

/*-----------------------------------------------------------------------------
						INITIAL GAMEMODE CODE STARTS HERE
-----------------------------------------------------------------------------*/
main(){}
 
public OnGameModeInit()
{
    SetGameModeText(SERVER_MODE);
	EnableAllAnimations(true);
	
	mysql_log(ERROR | WARNING | INFO);
    connection = mysql_connect(SQL_SERVER, SQL_USER, SQL_PASSWORD, SQL_DB);
    
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(true);
	SetNameTagDrawDistance(10.0);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
    ManualVehicleEngineAndLights();
    
    LoadAllMaps();
    LoadDoors();
    LoadHouses();
    LoadBusinesses();
    LoadFactions();
    LoadVehicles();
    LoadPlayerMDCLines();
    
    Time = TextDrawCreate(576.963073, 24.533348, "01:40");
	TextDrawLetterSize(Time, 0.487145, 1.582499);
	TextDrawAlignment(Time, TEXT_DRAW_ALIGN_CENTER);
	TextDrawColour(Time, -1);
	TextDrawSetShadow(Time, 0);
	TextDrawSetOutline(Time, 2);
	TextDrawBackgroundColour(Time, 255);
	TextDrawFont(Time, TEXT_DRAW_FONT_3);
	TextDrawSetProportional(Time, true);
	TextDrawSetShadow(Time, 0);
	
	SERVER_MESSAGE_COUNT = 0;
	SERVER_SECOND = 00;
	SERVER_MINUTE = 00;
	SERVER_HOUR = 00;
	GLOBALCHAT = 1;
	VEHICLEPROCESS = 0;
	
	LSPDJobTimer = 0;
	LSFDJobTimer = 0;
	MechanicJobTimer = 0;
	DudefixJobTimer = 0;
	LSPDJobTimerExp = 0;
	LSFDJobTimerExp = 0;
	MechanicJobTimerExp = 0;
	DudefixJobTimerExp = 0;
	BankRobberyTimer = 0;
	BankRobberyTimerExp = 0;
	TornadoTimer = 0;
	DrugTimer = 0;
	DrugActor = 0;
	DrugActorAmountHeld = 0;
	
	LSFDGateRightOpen = false;
	LSFDGateLeftOpen = false;
	LSFDGateBackOpen = false;
	LSFDGarageDoorOpen = false;
	LSFDTopDoorOpen = false;
	MechanicFrontGateOpen = false;
	BankDoorOpen = false;
	TowGateOpen = false;
	JunkYardGateOpen = false;
	

	for(new i; i<sizeof InfoPickups; i++)
	{
	   AddStaticPickup(1239, 1,InfoPickups[i][0], InfoPickups[i][1], InfoPickups[i][2], -1);
	}
	
	AddStaticPickup(19523, 1,1498.2710,-1581.8063,13.5498, -1);
	AddStaticPickup(19198, 1,267.2495,304.6546,999.1484+0.1, -1);
	
	CreateDynamicMapIcon(981.7843, -1161.1995, 25.0988, 52, -1, -1, -1, -1, -1); // BANK ICON
	CreateDynamicMapIcon(1175.2267, -1323.9321, 14.3906, 22, -1, -1, -1, -1, -1); // HOSPITAL ICON
	CreateDynamicMapIcon(1520.7346, -1452.2841, 14.2031, 42, -1, -1, -1, -1, -1); // TOW COMPANY ICON
	CreateDynamicMapIcon(1498.1787, -1583.8579, 13.5469, 40, -1, -1, -1, -1, -1); // HOTEL ICON
	CreateDynamicMapIcon(1548.8217, -1675.4998, 14.6926, 30, -1, -1, -1, -1, -1); // LSPD ICON
	CreateDynamicMapIcon(1768.6526, -1706.8606, 13.3870, 20, -1, -1, -1, -1, -1); // LSFD ICON
	CreateDynamicMapIcon(1939.5402, -1773.9280, 13.4234, 56, -1, -1, -1, -1, -1); // GAS STATION ICON
	CreateDynamicMapIcon(2067.5762, -1863.4712, 13.5633, 27, -1, -1, -1, -1, -1); // MECHANIC ICON
	CreateDynamicMapIcon(1409.7009, -2323.2712, 13.5469, 55, -1, -1, -1, -1, -1); // VEHICLE RENTAL ICON
	CreateDynamicMapIcon(1474.6604, -2286.6621, 42.4205, 5, -1, -1, -1, -1, -1); // TERMINAL RENTAL ICON
	CreateDynamicMapIcon(1015.9871,-1550.3489,14.8594, 55, -1, -1, -1, -1, -1); // CHEAP DEALERSHIP ICON
	CreateDynamicMapIcon(942.4840,-1743.0525,13.5546, 55, -1, -1, -1, -1, -1); // LUXARY DEALERSHIP ICON
	CreateDynamicMapIcon(1026.1846,-1771.0203,13.5469, 55, -1, -1, -1, -1, -1); // BIKE DEALERSHIP ICON
	
	LSFDGateRight = CreateDynamicObject(2957, 1771.98523, -1715.84265, 13.96486,   0.00000, 0.00000, 90.00000);
	LSFDGateLeft = CreateDynamicObject(2957, 1771.97620, -1697.25159, 13.96490,   0.00000, 0.00000, 90.00000);
	LSFDGateBack = CreateDynamicObject(2933, 1771.73315, -1687.46606, 14.04362,   0.00000, 0.00000, 270.00000);
	LSFDGarageDoor = CreateDynamicObject(1569, 1775.91125, -1701.51245, 12.24770,   0.00000, 0.00000, 0.00000);
	LSFDTopDoor = CreateDynamicObject(1569, 1782.34351, -1707.03296, 15.71100,   0.00000, 0.00000, 90.00000);
	MechanicFrontGate = CreateDynamicObject(7657, 2073.19141, -1869.90784, 14.24228,   0.00000, 0.00000, 90.00000);
	BankDoor = CreateDynamicObject(2634, 2144.19385, 1627.00122, 994.24762,   0.00000, 0.00000, 180.00000);
	TowGate = CreateDynamicObject(971, 1537.10388, -1451.24597, 15.92345,   0.00000, 0.00000, 180.00000);
	JunkYardGate = CreateDynamicObject(975, 1361.66724, -1467.49048, 13.20197,   0.00000, 0.00000, 75.00000);
	PaintSprayDoor = CreateDynamicObject(6400, 1951.66956, -1984.35400, 10.12055,   0.00000, 0.00000, 0.00000);
	
	new randIndex = random(sizeof(DrugDealerActorLocations));
	DrugActor = CreateActor(29, DrugDealerActorLocations[randIndex][0],DrugDealerActorLocations[randIndex][1],DrugDealerActorLocations[randIndex][2],DrugDealerActorLocations[randIndex][3]);
	DrugTimer = 0;
	DrugActorAmountHeld = 100;
	printf("New Drug Actor Created");
	
	LSPDBackupPosition[0] = 0;
	LSPDBackupPosition[1] = 0;
	LSPDBackupPosition[2] = 0;
	LSPDJobHouseInspection = 0;
	LSPDJobHouseInspectionAccepted = 0;
	LSFDJobHouseFire = 0;
	LSFDJobHouseFireID = 0;
	LSFDJobHouseFireAccepted = 0;
	LSFDJobHouseFireHealth = 0;
	LSFDJobHouseFireObject = 0;
	LSFDJobHouseSmokeObject = 0;
	MechanicJob = 0;
	MechanicJobAccepted = 0;
	MechanicJobID = 0;
	MechanicJobHealth = 0;
	DudefixJob = 0;
	DudefixJobAccepted = 0;
	
	SetTimer("ONE_SECOND_TIMER", 1000, true);
	
	printf("OnGamemodeInit Functions Established");
	
    return 1;
}
 
public OnGameModeExit()
{
    mysql_close(connection);
    return 1;
}
 
public OnPlayerRequestClass(playerid, classid)
{
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw1);
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw2);
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw3);
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw4);
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw5);
	PlayerTextDrawShow(playerid, PlayerText:LoginTextdraw6);
	
	SetPlayerPos(playerid, 2543.0171,-1625.4059,12.0512);
	
	TogglePlayerSpectating(playerid, true);
	InterpolateCameraPos(playerid, 2447.9524,-1652.4756,21.9614, 2447.9524,-1652.4756,21.9614, 6000,CAMERA_MOVE);
 	InterpolateCameraLookAt(playerid, 2514.5464,-1673.8757,13.6471, 2514.5464,-1673.8757,13.6471, 6000,CAMERA_MOVE);
 	
 	new query[128];
    GetPlayerName(playerid, PlayerData[playerid][Character_Name], MAX_PLAYER_NAME);
    ClearMessages(playerid);

    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, query, "OnAccountCheck", "i", playerid);
    
	return 1;
}
 
public OnPlayerConnect(playerid)
{
	if(strfind(GetName(playerid), "_", true) == -1)
	{
		SendPlayerErrorMessage(playerid, " This is a roleplay server, please pick a roleplay name (Example: Bob_Michaels)!");
		Kick(playerid);
	}
	
	RemoveBuildings(playerid);
	SetPlayerColor(playerid, COLOR_ORANGE);
	
	ApplyAnimation(playerid, "FINALE2", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "Flowers", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "FOOD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "Freeweights", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GANGS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GHANDS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GHETTO_DB", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "goggles", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GRAFFITI", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GRAVEYARD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GRENADE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "GYMNASIUM", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "HAIRCUTS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "HEIST9", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "INT_HOUSE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "INT_OFFICE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "INT_SHOP", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "JST_BUISNESS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "KART", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "KISSING", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "KNIFE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "LAPDAN1", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "LAPDAN2", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "LAPDAN3", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "LOWRIDER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MD_CHASE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MEDIC", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MD_END", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MISC", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MTB", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "MUSCULAR", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "NEVADA", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "ON_LOOKERS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "OTB", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PARACHUTE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PARK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PAULNMAC", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "ped", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PLAYER_DVBYS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PLAYIDLES", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "POLICE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "POOL", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "POOR", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PYTHON", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "QUAD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "QUAD_DBZ", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "RIFLE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "RIOT", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "ROB_BANK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "ROCKET", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "RUSTLER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "RYDER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SCRATCHING", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SHAMAL", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SHOTGUN", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SILENCED", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SKATE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SPRAYCAN", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "STRIP", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SUNBATHE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SWAT", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SWEET", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SWIM", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SWORD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "TANK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "TATTOOS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "TEC", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "TRAIN", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "TRUCK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "UZI", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "VAN", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "VENDING", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "VORTEX", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "WAYFARER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "WEAPONS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "WUZI", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SNM", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "BLOWJOBZ", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SEX", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "BOMBER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "RAPPING", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SHOP", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "BEACH", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "SMOKING", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "FOOD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "ON_LOOKERS", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "DEALER", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "CRACK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "CARRY", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "COP_AMBIENT", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "PARK", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "INT_HOUSE", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
	ApplyAnimation(playerid, "FOOD", "NULL", 4.1, false, false, false, false, 0, SYNC_ALL);
    
    IsPlayerLogged[playerid] = 0;
	IsPlayerSpectating[playerid] = 0;
    IsPlayerMuted[playerid] = 0;
    IsPlayerInjured[playerid] = 0;
    IsPlayerInHospital[playerid] = 0;
    IsPlayerRentingCar[playerid] = 0;
    IsPlayerStealingCar[playerid] = 0;
    IsPlayerWaitingHospital[playerid] = 0;
    IsPlayerStealingCarID[playerid] = 0;
    IsPlayerOnDuty[playerid] = 0;
    IsPlayerTased[playerid] = 0;
	IsPlayerInHelpMeCooldown[playerid] = 0;
    IsPlayerCuffed[playerid] = 0;
    IsNewVehicleType[playerid] = 0;
    IsPlayerDragged[playerid] = 0;
    WhoIsDragging[playerid] = 0;
    IsPlayerTied[playerid] = 0;
    IsPlayerDead[playerid] = 0;
	IsPlayerWeaponBanned[playerid] = 0;
	HasPlayerGotShovel[playerid] = 0;
	HasPlayerToggledHelpMe[playerid] = 0;
	HasPlayerFirstSpawned[playerid] = 0;
    HasPlayerConfirmedVehicleID[playerid] = 0;
    CanPlayerBuyVehicle[playerid] = 0;
    PlayerAtDoorID[playerid] = 0;
    PlayerAtHouseID[playerid] = 0;
    PlayerAtFactionID[playerid] = 0;
    MechanicFuelAmount[playerid] = 0;
    MechanicToolAmount[playerid] = 0;
	Binco_Current_Outfit[playerid] = 0;
	Binco_New_Outfit[playerid] = 0;
	Binco_Current_VW[playerid] = 0;
	HasPlayerTakenDrugs[playerid] = 0;
	HasPlayerBakedDrugs[playerid] = 0;
	HasPlayerChangedVehicleColour[playerid] = 0;
	HasPlayerEnteredSprayUnit[playerid] = 0;
	HasPlayerRequestAssistance[playerid] = 0;
	HasPlayerUsedMask[playerid] = 0;
	FoundPlayerHouseID[playerid] = 0;
	SpectateX[playerid] = 0;
	SpectateY[playerid] = 0;
	SpectateZ[playerid] = 0;
	DealershipType[playerid] = 0;
	IsPlayerUsingClient[playerid] = false;
	HasGPSBeenDisabled[playerid] = 0;
	
	PlayerDefaultPayment[playerid] = 1;
	
	LoginTextdraw1 = CreatePlayerTextDraw(playerid, 320.000000, -15.000000, "a");
	PlayerTextDrawFont(playerid, LoginTextdraw1, TEXT_DRAW_FONT_3);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw1, -1.299999, 15.999990);
	PlayerTextDrawTextSize(playerid, LoginTextdraw1, 490.000000, 659.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw1, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw1, 0xFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw1, true);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw1, 0xFF);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw1, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw1, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw1, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw1, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw1, true);

	LoginTextdraw2 = CreatePlayerTextDraw(playerid, 320.000000, 325.000000, "a");
	PlayerTextDrawFont(playerid, LoginTextdraw2, TEXT_DRAW_FONT_3);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw2, -1.299999, 15.999990);
	PlayerTextDrawTextSize(playerid, LoginTextdraw2, 490.000000, 659.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw2, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw2, 0xFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw2, true);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw2, 0xFF);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw2, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw2, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw2, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw2, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw2, true);

	LoginTextdraw3 = CreatePlayerTextDraw(playerid, 70.000000, 430.000000, "SCRIPT VERSION: %s", SERVER_VERSION);
	PlayerTextDrawFont(playerid, LoginTextdraw3, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw3, 0.300000, 1.000000);
	PlayerTextDrawTextSize(playerid, LoginTextdraw3, 510.000000, 210.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw3, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw3, 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw3, true);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw3, 0xAA);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw3, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw3, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw3, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw3, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw3, true);

	LoginTextdraw4 = CreatePlayerTextDraw(playerid, 320.000000, 66.000000, "OPEN ROLEPLAY");
	PlayerTextDrawFont(playerid, LoginTextdraw4, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw4, 0.600000, 3.499998);
	PlayerTextDrawTextSize(playerid, LoginTextdraw4, 510.000000, 210.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw4, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw4, 0x9F5AFDFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw4, true);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw4, 0xFF);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw4, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw4, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw4, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw4, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw4, true);

	LoginTextdraw5 = CreatePlayerTextDraw(playerid, 320.000000, 35.000000, "Welcome To");
	PlayerTextDrawFont(playerid, LoginTextdraw5, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw5, 0.600000, 3.499998);
	PlayerTextDrawTextSize(playerid, LoginTextdraw5, 510.000000, 210.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw5, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw5, 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw5, true);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw5, 0xFF);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw5, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw5, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw5, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw5, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw5, true);

	LoginTextdraw6 = CreatePlayerTextDraw(playerid, 320.000000, 343.000000, "Where your next adventure starts!");
	PlayerTextDrawFont(playerid, LoginTextdraw6, TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw6, 0.299999, 2.100000);
	PlayerTextDrawTextSize(playerid, LoginTextdraw6, 1020.000000, 390.000000);
	PlayerTextDrawAlignment(playerid, LoginTextdraw6, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, LoginTextdraw6, 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, LoginTextdraw6, false);
	PlayerTextDrawBoxColour(playerid, LoginTextdraw6, 0xFF);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw6, false);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw6, true);
	PlayerTextDrawBackgroundColour(playerid, LoginTextdraw6, 0xFF);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw6, true);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw6, true);
    
    Notification_Textdraw = CreatePlayerTextDraw(playerid,500.000000, 114.000000, "");
	PlayerTextDrawBackgroundColour(playerid,Notification_Textdraw, 255);
	PlayerTextDrawFont(playerid,Notification_Textdraw, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid,Notification_Textdraw, 0.220000, 1.200000);
	PlayerTextDrawColour(playerid,Notification_Textdraw, -1);
	PlayerTextDrawSetOutline(playerid,Notification_Textdraw, 0);
	PlayerTextDrawSetProportional(playerid,Notification_Textdraw, true);
	PlayerTextDrawSetShadow(playerid,Notification_Textdraw, 1);
	PlayerTextDrawUseBox(playerid,Notification_Textdraw, true);
	PlayerTextDrawBoxColour(playerid,Notification_Textdraw, 204);
	PlayerTextDrawTextSize(playerid,Notification_Textdraw, 606.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid,Notification_Textdraw, false);
	PlayerTextDrawHide(playerid, PlayerText:Notification_Textdraw);
	
	Store_Textdraw = CreatePlayerTextDraw(playerid,500.000000, 114.000000, "");
	PlayerTextDrawBackgroundColour(playerid,Store_Textdraw, 255);
	PlayerTextDrawFont(playerid,Store_Textdraw, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid,Store_Textdraw, 0.220000, 1.200000);
	PlayerTextDrawColour(playerid,Store_Textdraw, -1);
	PlayerTextDrawSetOutline(playerid,Store_Textdraw, 0);
	PlayerTextDrawSetProportional(playerid,Store_Textdraw, true);
	PlayerTextDrawSetShadow(playerid,Store_Textdraw, 1);
	PlayerTextDrawUseBox(playerid,Store_Textdraw, true);
	PlayerTextDrawBoxColour(playerid,Store_Textdraw, 204);
	PlayerTextDrawTextSize(playerid,Store_Textdraw, 606.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid,Store_Textdraw, false);
	PlayerTextDrawHide(playerid, PlayerText:Store_Textdraw);
	
	SpeedBoxFuelAmount = CreatePlayerTextDraw(playerid, 572.933105, 396.080047, "-");
	PlayerTextDrawLetterSize(playerid, SpeedBoxFuelAmount, 0.301333, 1.171911);
	PlayerTextDrawAlignment(playerid, SpeedBoxFuelAmount, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, SpeedBoxFuelAmount, -1);
	PlayerTextDrawSetShadow(playerid, SpeedBoxFuelAmount, 0);
	PlayerTextDrawSetOutline(playerid, SpeedBoxFuelAmount, 1);
	PlayerTextDrawBackgroundColour(playerid, SpeedBoxFuelAmount, 255);
	PlayerTextDrawFont(playerid, SpeedBoxFuelAmount, TEXT_DRAW_FONT_3);
	PlayerTextDrawSetProportional(playerid, SpeedBoxFuelAmount, true);
	PlayerTextDrawSetShadow(playerid, SpeedBoxFuelAmount, 0);
	PlayerTextDrawHide(playerid, PlayerText:SpeedBoxFuelAmount);

	SpeedBoxFuelTitle = CreatePlayerTextDraw(playerid, 572.509460, 407.528869, "FUEL");
	PlayerTextDrawLetterSize(playerid, SpeedBoxFuelTitle, 0.151111, 0.689067);
	PlayerTextDrawAlignment(playerid, SpeedBoxFuelTitle, TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColour(playerid, SpeedBoxFuelTitle, -1378294017);
	PlayerTextDrawSetShadow(playerid, SpeedBoxFuelTitle, 0);
	PlayerTextDrawSetOutline(playerid, SpeedBoxFuelTitle, 0);
	PlayerTextDrawBackgroundColour(playerid, SpeedBoxFuelTitle, 255);
	PlayerTextDrawFont(playerid, SpeedBoxFuelTitle, TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SpeedBoxFuelTitle, true);
	PlayerTextDrawSetShadow(playerid, SpeedBoxFuelTitle, 0);
	PlayerTextDrawHide(playerid, PlayerText:SpeedBoxFuelTitle);
	
	SpeedBoxSpeedTitle = CreatePlayerTextDraw(playerid, 526.000244, 408.026733, "KM/H");
	PlayerTextDrawLetterSize(playerid, SpeedBoxSpeedTitle, 0.175555, 0.669155);
	PlayerTextDrawAlignment(playerid, SpeedBoxSpeedTitle, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SpeedBoxSpeedTitle, -1378294017);
	PlayerTextDrawSetShadow(playerid, SpeedBoxSpeedTitle, 0);
	PlayerTextDrawSetOutline(playerid, SpeedBoxSpeedTitle, 0);
	PlayerTextDrawBackgroundColour(playerid, SpeedBoxSpeedTitle, 255);
	PlayerTextDrawFont(playerid, SpeedBoxSpeedTitle, TEXT_DRAW_FONT_1);
	PlayerTextDrawSetProportional(playerid, SpeedBoxSpeedTitle, true);
	PlayerTextDrawSetShadow(playerid, SpeedBoxSpeedTitle, 0);
	PlayerTextDrawHide(playerid, PlayerText:SpeedBoxSpeedTitle);
	
	SpeedBoxSpeedAmount = CreatePlayerTextDraw(playerid, 524.222167, 395.582153, "0");
	PlayerTextDrawLetterSize(playerid, SpeedBoxSpeedAmount, 0.342222, 1.316266);
	PlayerTextDrawAlignment(playerid, SpeedBoxSpeedAmount, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, SpeedBoxSpeedAmount, -1);
	PlayerTextDrawSetShadow(playerid, SpeedBoxSpeedAmount, 0);
	PlayerTextDrawSetOutline(playerid, SpeedBoxSpeedAmount, 1);
	PlayerTextDrawBackgroundColour(playerid, SpeedBoxSpeedAmount, 255);
	PlayerTextDrawFont(playerid, SpeedBoxSpeedAmount, TEXT_DRAW_FONT_3);
	PlayerTextDrawSetProportional(playerid, SpeedBoxSpeedAmount, true);
	PlayerTextDrawSetShadow(playerid, SpeedBoxSpeedAmount, 0);
	PlayerTextDrawHide(playerid, PlayerText:SpeedBoxSpeedAmount);
	
	if(IsPlayerUsingOfficialClient(playerid) == false)
	{
		IsPlayerUsingClient[playerid] = false;
	} 
	else
	{
		IsPlayerUsingClient[playerid] = true;		
	}
 
    return 1;
}
 
public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][Character_Registered] == 0) return 0;
    
    PlayerData[playerid][Character_Last_Login] = SERVER_HOUR;
    
    Save_Character_Info_Query_1(playerid);
    Save_Character_Info_Query_2(playerid);
    
    // PLAYER SIDED RESET
    PlayerData[playerid][Account_ID] = 0;
	PlayerData[playerid][Account_Email] = 0;
	PlayerData[playerid][Account_IP] = 0;
    PlayerData[playerid][Character_Name] = 0;
    PlayerData[playerid][Character_Password] = 0;
    PlayerData[playerid][Character_Registered] = 0;
    PlayerData[playerid][Character_Age] = 0;
    PlayerData[playerid][Character_Sex] = 0;
    PlayerData[playerid][Character_Birthplace] = 0;
    PlayerData[playerid][Character_Skin_1] = 0;
    PlayerData[playerid][Character_Skin_2] = 0;
    PlayerData[playerid][Character_Skin_3] = 0;
    PlayerData[playerid][Character_Skin_Logout] = 0;
	PlayerData[playerid][Character_Last_Login] = 0;
	PlayerData[playerid][Character_Minutes] = 0;
	PlayerData[playerid][Character_Ban] = 0;
	PlayerData[playerid][Character_Health] = 0;
	PlayerData[playerid][Character_Armor] = 0;
	PlayerData[playerid][Character_Job] = 0;
    PlayerData[playerid][Character_Faction] = 0;
    PlayerData[playerid][Character_Faction_Rank] = 0;
    PlayerData[playerid][Character_Faction_Join_Request] = 0;
    PlayerData[playerid][Character_Faction_Ban] = 0;
	PlayerData[playerid][Character_Money] = 0;
	PlayerData[playerid][Character_Coins] = 0;
	PlayerData[playerid][Character_Bank_Account] = 0;
	PlayerData[playerid][Character_Bank_Money] = 0;
	PlayerData[playerid][Character_Bank_Loan] = 0;
	PlayerData[playerid][Character_Bank_Pin] = 0;
	PlayerData[playerid][Character_VIP] = 0;
    PlayerData[playerid][Character_Pos_X] = 0;
    PlayerData[playerid][Character_Pos_Y] = 0;
    PlayerData[playerid][Character_Pos_Z] = 0;
    PlayerData[playerid][Character_Pos_Angle] = 0;
    PlayerData[playerid][Character_Interior_ID] = 0;
    PlayerData[playerid][Character_Virtual_World] = 0;
    PlayerData[playerid][Character_House_ID] = 0;
    PlayerData[playerid][Character_Business_ID] = 0;
    PlayerData[playerid][Character_Total_Houses] = 0;
    PlayerData[playerid][Character_Owns_Faction] = 0;
    PlayerData[playerid][Character_Total_Businesses] = 0;
	PlayerData[playerid][Character_Level] = 0;
	PlayerData[playerid][Character_Level_Exp] = 0;
	PlayerData[playerid][Character_Ticket_Amount] = 0;
	PlayerData[playerid][Character_Total_Ticket_Amount] = 0;
	PlayerData[playerid][Character_Jail] = 0;
	PlayerData[playerid][Character_Jail_Time] = 0;
	PlayerData[playerid][Character_Jail_Reason] = 0;
	PlayerData[playerid][Character_Last_Crime] = 0;
	PlayerData[playerid][Helper_Level] = 0;
	PlayerData[playerid][Moderator_Level] = 0;
	PlayerData[playerid][Admin_Level] = 0;
	PlayerData[playerid][Admin_Level_Exp] = 0;
	PlayerData[playerid][Admin_Jail] = 0;
	PlayerData[playerid][Admin_Jail_Time] = 0;
	PlayerData[playerid][Admin_Jail_Reason] = 0;
	PlayerData[playerid][Weapon_Slot_1] = 0;
	PlayerData[playerid][Weapon_Slot_2] = 0;
	PlayerData[playerid][Weapon_Slot_3] = 0;
	PlayerData[playerid][Weapon_Slot_4] = 0;
	PlayerData[playerid][Weapon_Slot_5] = 0;
	PlayerData[playerid][Weapon_Slot_6] = 0;
	PlayerData[playerid][Ammo_Slot_1] = 0;
	PlayerData[playerid][Ammo_Slot_2] = 0;
	PlayerData[playerid][Ammo_Slot_3] = 0;
	PlayerData[playerid][Ammo_Slot_4] = 0;
	PlayerData[playerid][Ammo_Slot_5] = 0;
	PlayerData[playerid][Ammo_Slot_6] = 0;
	PlayerData[playerid][Character_Radio] = 0;
	PlayerData[playerid][Character_License_Car] = 0;
	PlayerData[playerid][Character_License_Truck] = 0;
	PlayerData[playerid][Character_License_Motorcycle] = 0;
	PlayerData[playerid][Character_License_Boat] = 0;
	PlayerData[playerid][Character_License_Flying] = 0;
	PlayerData[playerid][Character_License_Firearms] = 0;
	PlayerData[playerid][Character_Drug_Cocaine] = 0;
	PlayerData[playerid][Character_Drug_Heroin] = 0;
	PlayerData[playerid][Character_Has_Rope] = 0;
	PlayerData[playerid][Character_Has_Fuelcan] = 0;
	PlayerData[playerid][Character_Has_Lockpick] = 0;
	PlayerData[playerid][Character_Has_Device] = 0;
	PlayerData[playerid][Character_Has_Drugs] = 0;
	PlayerData[playerid][Character_Has_Food] = 0;
	PlayerData[playerid][Character_Has_Mask] = 0;
	PlayerData[playerid][Character_Has_Drinks] = 0;
	PlayerData[playerid][Character_Has_Alcohol] = 0;
	PlayerData[playerid][Character_Has_Phone] = 0;
	PlayerData[playerid][Character_Phonenumber] = 0;
	PlayerData[playerid][Character_Has_SimCard] = 0;
	PlayerData[playerid][Character_Hotel_ID] = 0;
	PlayerData[playerid][Hotel_Character_Pos_X] = 0;
    PlayerData[playerid][Hotel_Character_Pos_Y] = 0;
    PlayerData[playerid][Hotel_Character_Pos_Z] = 0;
    PlayerData[playerid][Hotel_Character_Pos_Angle] = 0;
    PlayerData[playerid][Hotel_Character_Interior_ID] = 0;
    PlayerData[playerid][Hotel_Character_Virtual_World] = 0;
    PlayerData[playerid][Character_Total_Vehicles] = 0;
    
    // SERVER SIDED RESET
    MechanicJobPlayer[playerid] = 0;
    DudefixJobPlayer[playerid] = 0;
	LSFDJobHouseFirePlayer[playerid] = 0;
	LSPDJobHouseInpPlayer[playerid] = 0;
	IsPlayerLogged[playerid] = 0;
	IsPlayerSpectating[playerid] = 0;
	IsPlayerMuted[playerid] = 0;
	IsPlayerRentingCar[playerid] = 0;
	IsPlayerInHelpMeCooldown[playerid] = 0;
	IsPlayerStealingCar[playerid] = 0;
	IsPlayerStealingCarID[playerid] = 0;
	IsPlayerInjured[playerid] = 0;
	IsPlayerDead[playerid] = 0;
	IsPlayerInHospital[playerid] = 0;
	IsPlayerWeaponBanned[playerid] = 0;
	IsPlayerOnDuty[playerid] = 0;
	IsPlayerTased[playerid] = 0;
	Binco_Current_Outfit[playerid] = 0;
	Binco_New_Outfit[playerid] = 0;
	Binco_Current_VW[playerid] = 0;
	HasPlayerChangedVehicleColour[playerid] = 0;
	HasPlayerEnteredSprayUnit[playerid] = 0;
	HasPlayerRequestAssistance[playerid] = 0;
	HasPlayerUsedMask[playerid] = 0;
	FoundPlayerHouseID[playerid] = 0;
	IsPlayerCuffed[playerid] = 0;
	IsNewVehicleType[playerid] = 0;
	IsPlayerTied[playerid] = 0;
	IsPlayerDragged[playerid] = 0;
	MechanicFuelAmount[playerid] = 0;
	MechanicToolAmount[playerid] = 0;
	WhoIsDragging[playerid] = 0;
	WhoHasBeenSearched[playerid] = 0;
	WhoIsCalling[playerid] = 0;
	ApplicationLoanAmount[playerid] = 0;
	HasPlayerGotShovel[playerid] = 0;
	HasPlayerToggledHelpMe[playerid] = 0;
	HasPlayerFirstSpawned[playerid] = 0;
	HasPlayerBrokenIntoBank[playerid] = 0;
	HasPlayerRobbedBank[playerid] = 0;
	HasPlayerRobbedAmmunation[playerid] = 0;
	HasPlayerConfirmedVehicleID[playerid] = 0;
	HasCallBeenPickedUp[playerid] = 0;
	HasPlayerMadeACall[playerid] = 0;
	HasPlayerToggledOffDirectory[playerid] = 0;
	HasPlayerMadeAnEmergencyCall[playerid] = 0;
	EmergencyCallTypeRequired[playerid] = 0;
	EmergencyCallTypeReason[playerid] = 0;
	HasPlayerMadeRequestCall[playerid] = 0;
	RequestCallType[playerid] = 0;
	RequestCallReason[playerid] = 0;
	CanPlayerBuyVehicle[playerid] = 0;
	PlayerAtDoorID[playerid] = 0;
	PlayerAtHouseID[playerid] = 0;
	PlayerAtFactionID[playerid] = 0;
	PlayerAtBusinessID[playerid] = 0;
	PlayerAtBusinessBuyPointID[playerid] = 0;
	VehicleModelPurchasing[playerid] = 0;
	TruckJobParcelCount[playerid] = 0;
	TruckJobParcelPlayer[playerid] = 0;
	PizzaJobDeliveryPlayer[playerid] = 0;
	PizzaJobDeliveryCount[playerid] = 0;
	GarbageJobPlayer[playerid] = 0;
	GarbageJobCount[playerid] = 0;
	GarbageJobPosition[playerid] = 0;
	ElectricianLightJobPlayer[playerid] = 0;
	ElectricianLightJobCount[playerid] = 0;
	HasPlayerBakedDrugs[playerid] = 0;
	SpectateX[playerid] = 0;
	SpectateY[playerid] = 0;
	SpectateZ[playerid] = 0;
	DealershipType[playerid] = 0;
	IsPlayerUsingClient[playerid] = false;
	HasGPSBeenDisabled[playerid] = 0;
	PlayerDefaultPayment[playerid] = 0;
	
	GarbageObject[playerid] = 0;
	
	DrivingCarPlayer[playerid] = 0;
	DrivingCarCount[playerid] = 0;
	DrivingBikePlayer[playerid] = 0;
	DrivingBikeCount[playerid] = 0;
	DrivingTruckCount[playerid] = 0;
	DrivingTruckCount[playerid] = 0;
	
	GarbageObject[playerid] = 0;
	
	if(TruckJobMoneyPlayer[playerid] > 0)
	{
	    TruckJobMoneyStarted = 0;
     	TruckJobMoneyPlayer[playerid] = 0;
	}
	
	KillTimer(Notification_Timer[playerid]);
	KillTimer(Minute_Timer[playerid]);
	KillTimer(DoorEntry_Timer[playerid]);
	KillTimer(Drag_Timer[playerid]);
	KillTimer(Backup_Timer[playerid]);
	KillTimer(Fuel_Timer[playerid]);
	KillTimer(Repair_Timer[playerid]);
	KillTimer(Vehicle_Timer[playerid]);
	KillTimer(Refuel_Timer[playerid]);
	KillTimer(Hospital_Timer[playerid]);
	KillTimer(Hotwire_Timer[playerid]);
	KillTimer(Cooldown_Timer[playerid]);
	KillTimer(CrackDealer_Timer[playerid]);
	KillTimer(DrugUseCooldown_Timer[playerid]);
	KillTimer(Assistance_Timer[playerid]);
 	
 	Notification_Timer[playerid] = 0;
	Minute_Timer[playerid] = 0;
	DoorEntry_Timer[playerid] = 0;
	Drag_Timer[playerid] = 0;
	Backup_Timer[playerid] = 0;
	Fuel_Timer[playerid] = 0;
	Repair_Timer[playerid] = 0;
	Vehicle_Timer[playerid] = 0;
	Refuel_Timer[playerid] = 0;
	Hospital_Timer[playerid] = 0;
	Hotwire_Timer[playerid] = 0;
	Cooldown_Timer[playerid] = 0;
	CrackDealer_Timer[playerid] = 0;
	DrugUseCooldown_Timer[playerid] = 0;
	Assistance_Timer[playerid] = 0;
 	
    return 1;
}
 
public OnPlayerSpawn(playerid)
{
	if(IsPlayerDead[playerid] == 1)
	{
	    IsPlayerDead[playerid] = 0;
	    
	    if(IsPlayerInjured[playerid] == 1 && IsPlayerInHospital[playerid] == 0)
		{
		    IsPlayerInjured[playerid] = 0;
			IsPlayerInHospital[playerid] = 1;

	        SetPlayerPos(playerid, -1122.5582,1977.2639,-58.9141);
		 	SetPlayerFacingAngle(playerid, 235.7789);
		 	SetPlayerInterior(playerid, 0);

		 	SetPlayerHealth(playerid, 50);
		 	SetPlayerSkin(playerid, 62);

	        ClearMessages(playerid);
		 	SendClientMessage(playerid, COLOR_YELLOW, "Your character has just died during roleplay, please wait inside the hospital until your rest period is up!");

            TogglePlayerControllable(playerid,false);
			DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
    		Hospital_Timer[playerid] = SetTimerEx("HospitalTimer", 60000, false, "i", playerid);
	    }
	    else
	    {
	        IsPlayerInHospital[playerid] = 1;

	        SetPlayerPos(playerid, -1122.5582,1977.2639,-58.9141);
		 	SetPlayerFacingAngle(playerid, 235.7789);
		 	SetPlayerInterior(playerid, 0);

		 	SetPlayerHealth(playerid, 50);
		 	SetPlayerSkin(playerid, 62);

	        ClearMessages(playerid);
		 	SendClientMessage(playerid, COLOR_YELLOW, "Your character has just died [BUG MAYBE?], please wait inside the hospital until your rest period is up!");

            TogglePlayerControllable(playerid,false);
            DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
		 	Hospital_Timer[playerid] = SetTimerEx("HospitalTimer", 60000, false, "i", playerid);
	    }
	}
    return 1;
}
 
public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    IsPlayerDead[playerid] = 1;
    return 1;
}
 
public OnVehicleSpawn(vehicleid)
{
    return 1;
}
 
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You have been muted temp, please wait for an unmute!");
    if(!success) SendPlayerErrorMessage(playerid, " This command doesn't exist in our system, please use /commands for more info! [or /mcmds for smaller devices]");
	return 1;
}
 
public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}
 
public OnPlayerText(playerid, text[])
{
	if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
	else if(HasPlayerMadeAnEmergencyCall[playerid] == 1)
	{
	    if(EmergencyCallTypeRequired[playerid] == 0)
		{
	        if(strcmp(text, "police", false) == 0 || strcmp(text, "fire", false) == 0 || strcmp(text, "medical", false) == 0)
	        {
				if(strcmp(text, "police", false) == 0){ EmergencyCallTypeRequired[playerid] = 1; }
	            else if(strcmp(text, "fire", false) == 0){ EmergencyCallTypeRequired[playerid] = 2; }
	            else if(strcmp(text, "medical", false) == 0){ EmergencyCallTypeRequired[playerid] = 3; }

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
                SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);
		
	            new string[256];
				format(string, sizeof(string), "[Phone] Emergency Responder says: What is the reason for this Emergency?");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
	        }
	        else
	        {
	            new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);
				
	            new string[256];
				format(string, sizeof(string), "[Phone] Emergency Responder says: Sorry, can you repeat that. Who is required? (police, fire or medical)");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
	        }
	    }
	    else if(EmergencyCallTypeRequired[playerid] == 1 && EmergencyCallTypeReason[playerid] == 0)
	    {
	        if(strlen(text) != 0)
	        {
	            new reason[256];
	            format(reason, sizeof(reason), "%s", text);
				strcpy(EmergencyCallTypeReason[playerid], reason);

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);
				
	            new string[256];
				format(string, sizeof(string), "[Phone] Emergency Responder says: Thank you, we will see if there are any avaliable units to respond!");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
				
	 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
			   	SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			   	
			   	new dstring[256];
      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We have a new call that needs attention! [/acceptcall (job id)])");
				SendFactionRadioMessage(1, COLOR_WHITE, dstring);
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Report ID: %d | Reason: %s)", playerid, text);
				SendFactionRadioMessage(1, COLOR_WHITE, dstring);
	        }
	    }
	    else if(EmergencyCallTypeRequired[playerid] == 2 && EmergencyCallTypeReason[playerid] == 0)
	    {
	        if(strlen(text) != 0)
	        {
	            new reason[256];
	            format(reason, sizeof(reason), "%s", text);
				strcpy(EmergencyCallTypeReason[playerid], reason);

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Emergency Responder says: Thank you, we will see if there are any avaliable units to respond!");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

	 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
			   	SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);

			   	new dstring[256];
      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We have a new call that needs attention! [/acceptcall (job id)])");
				SendFactionRadioMessage(2, COLOR_WHITE, dstring);
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Report ID: %d | Reason: %s", playerid, text);
				SendFactionRadioMessage(2, COLOR_WHITE, dstring);
	        }
	    }
	    else if(EmergencyCallTypeRequired[playerid] == 3 && EmergencyCallTypeReason[playerid] == 0)
	    {
	        if(strlen(text) != 0)
	        {
	            new reason[256];
	            format(reason, sizeof(reason), "%s", text);
				strcpy(EmergencyCallTypeReason[playerid], reason);

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Emergency Responder says: Thank you, we will see if there are any avaliable units to respond!");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

	 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
			   	SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);

			   	new dstring[256];
      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We have a new call that needs attention! [/acceptcall (job id)])");
				SendFactionRadioMessage(3, COLOR_WHITE, dstring);
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Report ID: %d | Reason: %s)", playerid, text);
				SendFactionRadioMessage(3, COLOR_WHITE, dstring);
	        }
	    }
	}
	else if(HasPlayerMadeRequestCall[playerid] == 1)
	{
	    if(RequestCallType[playerid] == 0)
		{
	        if(strcmp(text, "yes", false) == 0 || strcmp(text, "no", false) == 0)
	        {
				if(strcmp(text, "yes", false) == 0)
				{
					RequestCallType[playerid] = 1;

                    new message[128];
					format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

		            new string[256];
					format(string, sizeof(string), "[Phone] Mechanic Dispatch says: What is the reason for this call? Vehicle refuel? vehicle tow?");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
				}
	            else if(strcmp(text, "no", false) == 0)
				{
					RequestCallType[playerid] = 0;
					HasPlayerMadeRequestCall[playerid] = 0;
					
					new string[256];
					format(string, sizeof(string), "[Phone] Mechanic Dispatch says: We require to know where our client is located, please call again later!");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
				}
	        }
	        else
	        {
	            new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Mechanic Dispatch says: Sorry, can you repeat that. Do you need assistance at your current location?");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
	        }
	    }
	    else if(RequestCallType[playerid] == 1 && RequestCallReason[playerid] == 0)
	    {
	        if(strlen(text) != 0)
	        {
	            new reason[256];
	            format(reason, sizeof(reason), "%s", text);
				strcpy(RequestCallReason[playerid], reason);

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
                SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Mechanic Dispatch says: Thank you, we will see if there are any avaliable units to respond!");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

	 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
			   	SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);

			   	new dstring[256];
      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We have a new call that needs attention! [/acceptcall (job id)])");
				SendFactionRadioMessage(9, COLOR_WHITE, dstring);
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Report ID: %d | Reason: %s)", playerid, text);
				SendFactionRadioMessage(9, COLOR_WHITE, dstring);
	        }
	    }
	}
	else if(HasPlayerMadeRequestCall[playerid] == 2)
	{
	    if(RequestCallType[playerid] == 0)
		{
	        if(strcmp(text, "yes", false) == 0 || strcmp(text, "no", false) == 0)
	        {
				if(strcmp(text, "yes", false) == 0)
				{
					RequestCallType[playerid] = 1;

                    new message[128];
					format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

		            new string[256];
					format(string, sizeof(string), "[Phone] Towing Dispatch says: What is the reason for this call? Vehicle refuel? vehicle tow?");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
				}
	            else if(strcmp(text, "no", false) == 0)
				{
					RequestCallType[playerid] = 0;
					HasPlayerMadeRequestCall[playerid] = 0;

					new string[256];
					format(string, sizeof(string), "[Phone] Towing Dispatch says: We require to know where our client is located, please call again later!");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
				}
	        }
	        else
	        {
	            new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
				SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Towing Dispatch says: Sorry, can you repeat that. Do you need assistance at your current location?");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);
	        }
	    }
	    else if(RequestCallType[playerid] == 1 && RequestCallReason[playerid] == 0)
	    {
	        if(strlen(text) != 0)
	        {
	            new reason[256];
	            format(reason, sizeof(reason), "%s", text);
				strcpy(RequestCallReason[playerid], reason);

                new message[128];
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
                SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

	            new string[256];
				format(string, sizeof(string), "[Phone] Towing Dispatch says: Thank you, we will see if there are any avaliable units to respond!");
				SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

	 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
			   	SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);

			   	new dstring[256];
      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We have a new call that needs attention! [/acceptcall (job id)])");
				SendFactionRadioMessage(5, COLOR_WHITE, dstring);
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Report ID: %d | Reason: %s)", playerid, text);
				SendFactionRadioMessage(5, COLOR_WHITE, dstring);
	        }
	    }
	}
	else if(HasCallBeenPickedUp[playerid] == 1)
	{
	    new message[128];
		format(message, sizeof(message), "[Phone] %s says: %s", GetName(WhoIsCalling[playerid]), text);
		SendNearbyMessage(playerid, 5.0, COLOR_WHITE, message);
		
		new messagecount = 0;
		
		for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
		{
			if(WhoIsCalling[targetid] == playerid && messagecount == 0)
			{
				messagecount = 1;
				
				format(message, sizeof(message), "[Phone] %s says: %s", GetName(playerid), text);
                SendNearbyMessage(playerid, 5.0, COLOR_WHITE, message);
			}
			else return 0;
		}
	}
	else
	{
		new message[128];
	 	format(message, sizeof(message), "%s says: %s", GetName(playerid), text);
		SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);
	}
    return 0;
}
 
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}
 
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}
 
public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}
 
public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
	new string[256];
	new veh = GetPlayerVehicleID(playerid);
	new vehicleModel = GetVehicleModel(veh);
	
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		PlayerTextDrawShow(playerid, PlayerText:SpeedBoxFuelAmount);
		PlayerTextDrawShow(playerid, PlayerText:SpeedBoxFuelTitle);
		PlayerTextDrawShow(playerid, PlayerText:SpeedBoxSpeedAmount);
		PlayerTextDrawShow(playerid, PlayerText:SpeedBoxSpeedTitle);
			
	    new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);

		if(engine == 1)
		{
	        Fuel_Timer[playerid] = SetTimerEx("FuelTimer", 10000, true);
	        Vehicle_Timer[playerid] = SetTimerEx("VehicleTimer", 250, true, "i", playerid);
	        
	        printf("%s has entered a vehicle that has its engine on - timer started", GetName(playerid));
		}
		
		if(IsDrivingVehicle(playerid))
	    {
	        if(DrivingBikePlayer[playerid] == 0 && GetVehicleModel(veh) == 462 && PlayerData[playerid][Admin_Level] < 5)
	        {
		        RemovePlayerFromVehicle(playerid);
	         	SendPlayerErrorMessage(playerid, " You are not completing a motorcycle driving test, you cannot use this vehicle!");

	            printf("%s was kicked out of a driving license vehicle", GetName(playerid));
			}
			else if(DrivingCarPlayer[playerid] == 0 && GetVehicleModel(veh) == 400 && PlayerData[playerid][Admin_Level] < 5)
	        {
		        RemovePlayerFromVehicle(playerid);
	         	SendPlayerErrorMessage(playerid, " You are not completing a car driving test, you cannot use this vehicle!");

	            printf("%s was kicked out of a driving license vehicle", GetName(playerid));
			}
			else if(DrivingTruckPlayer[playerid] == 0 && GetVehicleModel(veh) == 456 && PlayerData[playerid][Admin_Level] < 5)
	        {
		        RemovePlayerFromVehicle(playerid);
	         	SendPlayerErrorMessage(playerid, " You are not completing a truck driving test, you cannot use this vehicle!");

	            printf("%s was kicked out of a driving license vehicle", GetName(playerid));
			}
	    }
		if(IsRentalVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(IsPlayerRentingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not renting any vehicles, you cannot use this vehicle!");

                printf("%s was kicked out of a rental vehicle", GetName(playerid));
			}
	    }
	    if(IsLSPDVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 1 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the LSPD Faction, you cannot use this vehicle!");
                
                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 1 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;
   		        
                format(string, sizeof(string), "- You have stolen a LSPD vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsLSFDVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 2 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
		        SendPlayerErrorMessage(playerid, " You are not within the LSFD Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 2 && IsPlayerStealingCar[playerid] == 2)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a LSFD vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsLSMCVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 3 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
		        SendPlayerErrorMessage(playerid, " You are not within the LSMC Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 3 && IsPlayerStealingCar[playerid] == 3)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a LSMC vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
		if(IsPizzaVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Job] != 1 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Pizza Devliery Team, you cannot use this vehicle!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}
			/*else if(PlayerData[playerid][Character_Job] != 1 && PizzaJobDeliveryPlayer[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not currently doing a delivery service. Use /startjob to commence work!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}*/
			else if(PlayerData[playerid][Character_Faction] != 4 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Pizza Delivery vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
		if(IsGarbageVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Job] != 2 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Garabge Collection Team, you cannot use this vehicle!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}
			/*else if(PlayerData[playerid][Character_Job] != 2 && GarbageJobPlayer[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not currently doing a collection service. Use /startjob to commence work!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}*/
			else if(PlayerData[playerid][Character_Faction] != 4 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Garbage Collection vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
		if(IsElectricianVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Job] != 3 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Electrician Guild, you cannot use this vehicle!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}
			/*else if(PlayerData[playerid][Character_Job] != 3 && ElectricianLightJobPlayer[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not currently doing an electrical route. Use /startjob to commence work!");

                printf("%s was kicked out of a job vehicle", GetName(playerid));
			}*/
			else if(PlayerData[playerid][Character_Faction] != 4 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen an Electrician Guild vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsBankVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 4 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Bank Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 4 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Bank vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsTowVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 5 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Two Co Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 5 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Towing vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsTaxiVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 6 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Taxi Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 6 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Taxi vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsTruckCoVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 7 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Trucking Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 7 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Trucking vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsDudeFixVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 8 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Dudefix Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 8 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Dudefix vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsMechanicVehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 9 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
		        SendPlayerErrorMessage(playerid, " You are not within the Mechanic Faction, you cannot use this vehicle!");

                printf("%s was kicked out of a faction vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 9 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a Mechanic vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsGang1Vehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 10 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Gang, you cannot use this vehicle!");

                printf("%s was kicked out of a gang vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 10 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a gang vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsGang2Vehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 11 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Gang, you cannot use this vehicle!");

                printf("%s was kicked out of a gang vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 11 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a gang vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    if(IsGang3Vehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 12 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Gang, you cannot use this vehicle!");

                printf("%s was kicked out of a gang vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 12 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a gang vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
		if(IsGang4Vehicle(playerid) && PlayerData[playerid][Character_Faction] != 5 && PlayerData[playerid][Admin_Level] < 5)
	    {
	        if(PlayerData[playerid][Character_Faction] != 13 && IsPlayerStealingCar[playerid] == 0)
   		    {
	        	RemovePlayerFromVehicle(playerid);
                SendPlayerErrorMessage(playerid, " You are not within the Gang, you cannot use this vehicle!");

                printf("%s was kicked out of a gang vehicle", GetName(playerid));
			}
			else if(PlayerData[playerid][Character_Faction] != 13 && IsPlayerStealingCar[playerid] == 1)
   		    {
   		        IsPlayerStealingCar[playerid] = 0;
  				IsPlayerStealingCarID[playerid] = 0;

                format(string, sizeof(string), "- You have stolen a gang vehicle, if you leave it, you will have to re /hotwire it!");
				SendClientMessage(playerid, COLOR_YELLOW, string);

                printf("%s has stolen a vehicle by hot wiring it", GetName(playerid));
			}
	    }
	    
     	if(IsTruckVehicle(vehicleModel) == 1 && PlayerData[playerid][Character_License_Truck] == 0)
		{
	        format(string, sizeof(string), "- You are attempting to operate a heavy vehicle without a truck license!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
	    }
		else if(IsMotorcycle(vehicleModel) == 1 && PlayerData[playerid][Character_License_Motorcycle] == 0)
	    {
	        format(string, sizeof(string), "- You are attempting to operate a motorcycle without a motorcycle license!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else if(IsAircraft(vehicleModel) == 1 && PlayerData[playerid][Character_License_Flying] == 0)
	    {
        	format(string, sizeof(string), "- You are attempting to operate an air vehicle without a pilots license!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
	    else if(IsBoat(vehicleModel) == 1 && PlayerData[playerid][Character_License_Boat] == 0)
	    {
	        format(string, sizeof(string), "- You are attempting to operate a vessel without a boat license!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else if(IsBoat(vehicleModel) == 0 && IsAircraft(vehicleModel) == 0 && IsMotorcycle(vehicleModel) == 0 && IsTruckVehicle(vehicleModel) == 0 && PlayerData[playerid][Character_License_Car] == 0)
		{
            format(string, sizeof(string), "- You are attempting to operate a car without a drivers license!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		PlayerTextDrawHide(playerid, PlayerText:SpeedBoxFuelAmount);
		PlayerTextDrawHide(playerid, PlayerText:SpeedBoxFuelTitle);
		PlayerTextDrawHide(playerid, PlayerText:SpeedBoxSpeedAmount);
		PlayerTextDrawHide(playerid, PlayerText:SpeedBoxSpeedTitle);
		
	    KillTimer(Fuel_Timer[playerid]);
     	KillTimer(Vehicle_Timer[playerid]);

        Fuel_Timer[playerid] = 0;
		Vehicle_Timer[playerid] = 0;
		
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);
		
		if(engine == 1)
		{
			printf("%s exited a vehicle without turning the engine off - timer killed", GetName(playerid));
		}
		else if(engine == 0)
		{
		    printf("%s exited a vehicle that wasn't on", GetName(playerid));
		}
	}
    return 1;
}
 
public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
		
	if(GPSOn[playerid] == true)
	{
	    GPSOn[playerid] = false;
	    DisablePlayerCheckpoint(playerid);
	}
	if(DudefixJobAccepted == 1 && DudefixJobPlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	}
	if(ElectricianLightJobPlayer[playerid] == 1)
	{	
		if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be outside of your vehicle to complete this job!");
		else
		{
			DisablePlayerCheckpoint(playerid);
			
			if(ElectricianLightJobCount[playerid] < 5)
			{
				new string[256];
			    format(string, sizeof(string), "> %s removes from tools from their belt and starts to repair the light", GetName(playerid));
			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			
				GameTextForPlayer(playerid, "FIXING LIGHT...", 3000, 3);
			
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
				
				ElectricianLightJobCount[playerid] += 1;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just repaired a traffic light, move onto your next location!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
					
				new randIndex = random(sizeof(ElectricianJob1));
				SetPlayerCheckpoint(playerid, ElectricianJob1[randIndex][0],ElectricianJob1[randIndex][1],ElectricianJob1[randIndex][2], 3.0);
			}
			else if(ElectricianLightJobCount[playerid] == 5)
			{
				new string[256];
			    format(string, sizeof(string), "> %s removes from tools from their belt and starts to repair the light", GetName(playerid));
			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			
				GameTextForPlayer(playerid, "FIXING LIGHT...", 3000, 3);
				
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
				
				ElectricianLightJobCount[playerid] = 0;
				ElectricianLightJobPlayer[playerid] = 0;
				
				PlayerData[playerid][Character_Money] += 450;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just completed your job route and earned some money in the process!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				HasGPSBeenDisabled[playerid] = 0;
			}
		}
	}
	if(GarbageJobPlayer[playerid] == 1)
	{	
		if(GarbageJobCount[playerid] <= 10 && GarbageJobPosition[playerid] == 0)
		{			
			new Float:pX, Float:pY, Float:pZ;
		    GetPlayerPos(playerid, pX, pY, pZ);
		
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
	
			SetPlayerAttachedObject(playerid, GarbageObject[playerid], 1264, 6);
			
			GarbageJobPosition[playerid] = 1;

		    new string[256];
		    format(string, sizeof(string), "> %s picks up a rubbish item from the front door", GetName(playerid));
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
		
		    new vid;
		    new Float:vPos[3];
		
		    vid = GetNearestVehicleModel(playerid, 408); 
		
		    if (vid != INVALID_VEHICLE_ID)
		    {
		        GetVehiclePos(vid, vPos[0], vPos[1], vPos[2]);
		       
		        new Float:rearPos[3];
		        rearPos[0] = vPos[0] - 1.0; 
		        rearPos[1] = vPos[1];
		        rearPos[2] = vPos[2];
		        
		        SetPlayerCheckpoint(playerid, rearPos[0], rearPos[1], rearPos[2], 3.0);
		    }
		    else
		    {
		        SendPlayerErrorMessage(playerid, " There is no rubbish truck in your area. Use /stopjob now and go find one!");
		    }
		}	
		else if(GarbageJobCount[playerid] <= 10  && GarbageJobPosition[playerid] == 1)
		{
			GarbageJobCount[playerid] += 1;
			GarbageJobPosition[playerid] = 0;
			
			RemovePlayerAttachedObject(playerid, GarbageObject[playerid]);
	        GarbageObject[playerid] = 0;
				
			new string[256];
			format(string, sizeof(string), "> %s throws the rubbish into the back of the truck", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
			ApplyAnimation(playerid, "INT_SHOP", "shop_shelf", 4.0, false, false, false, false, 0);
				
			new randomNumber = GetValidHouseJobNumber();
			SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 3.0);
		}
		else if(GarbageJobCount[playerid] == 11)
		{
			GarbageJobCount[playerid] += 1;
			
			new string[256];
			format(string, sizeof(string), "> %s picks up a rubbish item from the front door and carries it to the truck", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
			new dstring[256];
			format(dstring, sizeof(dstring), "- You now have a full truck, go and dump the truck at the depo!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			SetPlayerCheckpoint(playerid, 2188.8066,-1988.3834,13.5469, 3.0);
		}
		else if(GarbageJobCount[playerid] == 12)
		{
			GarbageJobCount[playerid] = 0;
			GarbageJobPlayer[playerid] = 0;
			
			PlayerData[playerid][Character_Money] += 600;
			
			new string[256];
			format(string, sizeof(string), "> %s backs the truck up and dumps the contents onto the ground", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
			HasGPSBeenDisabled[playerid] = 0;
			
			new dstring[256];
			format(dstring, sizeof(dstring), "- You have just emptied your vehicle, feel free to keep going by typing /startjob again!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
		}
	}
	if(PizzaJobDeliveryPlayer[playerid] == 1)
	{
		if(PizzaJobDeliveryCount[playerid] == 1)
		{
			PizzaJobDeliveryCount[playerid] = 2;
			
			ApplyAnimation(playerid, "ped", "ATM", 4.0, false, false, false, false, 0);
					
			new string[256];
			format(string, sizeof(string), "> %s logs into the register and prints off an order", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
					
			SetPlayerCheckpoint(playerid, 373.7656, -113.9339, 1001.4922, 0.5);
		}
		else if(PizzaJobDeliveryCount[playerid] == 2)
		{
			PizzaJobDeliveryCount[playerid] = 3;
			
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
				
			new string[256];
			format(string, sizeof(string), "> %s reaches down into the cabinet and pulls out the items and makes the pizza", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
					
			SetPlayerCheckpoint(playerid, 376.8524, -113.7040, 1001.4922, 0.5);
		}
		else if(PizzaJobDeliveryCount[playerid] == 3)
		{
			PizzaJobDeliveryCount[playerid] = 4;
			
			ApplyAnimation(playerid, "ped", "ATM", 4.0, false, false, false, false, 0);
				
			new string[256];
			format(string, sizeof(string), "> %s places the pizza into the oven for cooking", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
					
			SetPlayerCheckpoint(playerid, 379.0675, -114.3917, 1001.4922, 0.5);
		}
		else if(PizzaJobDeliveryCount[playerid] == 4)
		{
			PizzaJobDeliveryCount[playerid] = 5;
			
			ApplyAnimation(playerid, "ped", "ATM", 4.0, false, false, false, false, 0);
				
			new string[256];
			format(string, sizeof(string), "> %s removes the pizza from the oven and boxes it up", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
			new dstring[256];
			format(dstring, sizeof(dstring), "- You have just completed making a pizza, go and deliver the pizza to the customer!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
					
			new randomNumber = GetValidHouseJobNumber();
			SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 3.0);
		}
		else if(PizzaJobDeliveryCount[playerid] == 5)
		{
			PizzaJobDeliveryCount[playerid] = 6;
				
			new string[256];
			format(string, sizeof(string), "> %s passes the pizza over to the customer and receives their pay", GetName(playerid));
			SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
			ApplyAnimation(playerid, "ped", "ATM", 4.0, false, false, false, false, 0);
			
			PlayerData[playerid][Character_Money] += 250;
			
			new dstring[256];
			format(dstring, sizeof(dstring), "- Go back to the pizza store to confirm new delivery or /stopjob now!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
					
			SetPlayerCheckpoint(playerid, 2096.3193, -1787.8599, 13.5559, 3.0);
		}
		else if(PizzaJobDeliveryCount[playerid] == 6)
		{
			ShowPlayerDialog(playerid, DIALOG_PIZZA_END, DIALOG_STYLE_MSGBOX, "Pizza Delivery Job - Completion", "Thank you for creating a pizza and delivering it to our most valued customers.\n\nWould you like to complete another delivery?", "Yes", "No");
		}
	}
	if(DrivingBikeCount[playerid] > 0 && DrivingBikePlayer[playerid] == 1 && IsDrivingVehicle(playerid))
	{
	    new playerVehicleID = GetPlayerVehicleID(playerid);

		if (GetVehicleModel(playerVehicleID) == 462)
		{
		    DisablePlayerCheckpoint(playerid);

            DrivingBikeCount[playerid] ++;

	        new dstring[256];
			format(dstring, sizeof(dstring), "- Your next marker is on your map! (%d/18)", DrivingBikeCount[playerid]-1);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			if(DrivingBikeCount[playerid] == 2) { SetPlayerCheckpoint(playerid, 1355.1953,-1418.6083,12.9861, 5.0); }
			else if(DrivingBikeCount[playerid] == 3) { SetPlayerCheckpoint(playerid, 1271.8380,-1398.6841,12.6198, 5.0); }
			else if(DrivingBikeCount[playerid] == 4) { SetPlayerCheckpoint(playerid, 1211.6638,-1397.8444,12.8466, 5.0); }
			else if(DrivingBikeCount[playerid] == 5) { SetPlayerCheckpoint(playerid, 1199.1884,-1406.5869,12.8528, 5.0); }
			else if(DrivingBikeCount[playerid] == 6) { SetPlayerCheckpoint(playerid, 1194.0056,-1470.3920,12.9802, 5.0); }
			else if(DrivingBikeCount[playerid] == 7) { SetPlayerCheckpoint(playerid, 1199.9183,-1573.2540,12.9779, 5.0); }
			else if(DrivingBikeCount[playerid] == 8) { SetPlayerCheckpoint(playerid, 1272.2620,-1574.9789,12.9782, 5.0); }
			else if(DrivingBikeCount[playerid] == 9) { SetPlayerCheckpoint(playerid, 1294.0011,-1585.9316,12.9782, 5.0); }
			else if(DrivingBikeCount[playerid] == 10) { SetPlayerCheckpoint(playerid, 1299.2527,-1790.5067,12.9785, 5.0); }
			else if(DrivingBikeCount[playerid] == 11) { SetPlayerCheckpoint(playerid, 1304.2068,-1847.6902,12.9778, 5.0); }
			else if(DrivingBikeCount[playerid] == 12) { SetPlayerCheckpoint(playerid, 1309.7480,-1833.2544,12.9788, 5.0); }
			else if(DrivingBikeCount[playerid] == 13) { SetPlayerCheckpoint(playerid, 1310.1819,-1716.8820,12.9803, 5.0); }
			else if(DrivingBikeCount[playerid] == 14) { SetPlayerCheckpoint(playerid, 1310.5149,-1603.0090,12.9803, 5.0); }
			else if(DrivingBikeCount[playerid] == 15) { SetPlayerCheckpoint(playerid, 1314.0156,-1574.5985,12.9786, 5.0); }
			else if(DrivingBikeCount[playerid] == 16) { SetPlayerCheckpoint(playerid, 1343.3987,-1492.9025,12.9881, 5.0); }
			else if(DrivingBikeCount[playerid] == 17) { SetPlayerCheckpoint(playerid, 1362.5438,-1441.2408,13.1347, 5.0); }
			else if(DrivingBikeCount[playerid] == 18) { SetPlayerCheckpoint(playerid, 1376.4298,-1437.6281,13.1409, 5.0); }
			else if(DrivingBikeCount[playerid] == 19)
			{
			    SetVehicleToRespawn(GetPlayerVehicleID(playerid));

			    DrivingBikePlayer[playerid] = 0;
				DrivingBikeCount[playerid] = 0;

				PlayerData[playerid][Character_License_Motorcycle] = 1;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_motorcycle` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_License_Motorcycle], GetName(playerid));
				mysql_tquery(connection, updatequery);

				format(dstring, sizeof(dstring), "- You congratulations you have just obtained your motorocycle license");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				HasGPSBeenDisabled[playerid] = 0;
			}
		}
	}
	if(DrivingCarCount[playerid] > 0 && DrivingCarPlayer[playerid] == 1 && IsDrivingVehicle(playerid))
	{
	    new playerVehicleID = GetPlayerVehicleID(playerid);

		if (GetVehicleModel(playerVehicleID) == 400)
		{
		    DisablePlayerCheckpoint(playerid);

            DrivingCarCount[playerid] ++;

	        new dstring[256];
			format(dstring, sizeof(dstring), "- Your next marker is on your map! (%d/18)", DrivingCarCount[playerid]-1);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			if(DrivingCarCount[playerid] == 2) { SetPlayerCheckpoint(playerid, 1355.1953,-1418.6083,12.9861, 5.0); }
			else if(DrivingCarCount[playerid] == 3) { SetPlayerCheckpoint(playerid, 1271.8380,-1398.6841,12.6198, 5.0); }
			else if(DrivingCarCount[playerid] == 4) { SetPlayerCheckpoint(playerid, 1211.6638,-1397.8444,12.8466, 5.0); }
			else if(DrivingCarCount[playerid] == 5) { SetPlayerCheckpoint(playerid, 1199.1884,-1406.5869,12.8528, 5.0); }
			else if(DrivingCarCount[playerid] == 6) { SetPlayerCheckpoint(playerid, 1194.0056,-1470.3920,12.9802, 5.0); }
			else if(DrivingCarCount[playerid] == 7) { SetPlayerCheckpoint(playerid, 1199.9183,-1573.2540,12.9779, 5.0); }
			else if(DrivingCarCount[playerid] == 8) { SetPlayerCheckpoint(playerid, 1272.2620,-1574.9789,12.9782, 5.0); }
			else if(DrivingCarCount[playerid] == 9) { SetPlayerCheckpoint(playerid, 1294.0011,-1585.9316,12.9782, 5.0); }
			else if(DrivingCarCount[playerid] == 10) { SetPlayerCheckpoint(playerid, 1299.2527,-1790.5067,12.9785, 5.0); }
			else if(DrivingCarCount[playerid] == 11) { SetPlayerCheckpoint(playerid, 1304.2068,-1847.6902,12.9778, 5.0); }
			else if(DrivingCarCount[playerid] == 12) { SetPlayerCheckpoint(playerid, 1309.7480,-1833.2544,12.9788, 5.0); }
			else if(DrivingCarCount[playerid] == 13) { SetPlayerCheckpoint(playerid, 1310.1819,-1716.8820,12.9803, 5.0); }
			else if(DrivingCarCount[playerid] == 14) { SetPlayerCheckpoint(playerid, 1310.5149,-1603.0090,12.9803, 5.0); }
			else if(DrivingCarCount[playerid] == 15) { SetPlayerCheckpoint(playerid, 1314.0156,-1574.5985,12.9786, 5.0); }
			else if(DrivingCarCount[playerid] == 16) { SetPlayerCheckpoint(playerid, 1343.3987,-1492.9025,12.9881, 5.0); }
			else if(DrivingCarCount[playerid] == 17) { SetPlayerCheckpoint(playerid, 1362.5438,-1441.2408,13.1347, 5.0); }
			else if(DrivingCarCount[playerid] == 18) { SetPlayerCheckpoint(playerid, 1376.4298,-1437.6281,13.1409, 5.0); }
			else if(DrivingCarCount[playerid] == 19)
			{
			    SetVehicleToRespawn(GetPlayerVehicleID(playerid));

			    DrivingCarPlayer[playerid] = 0;
				DrivingCarCount[playerid] = 0;

				PlayerData[playerid][Character_License_Car] = 1;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_car` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_License_Car], GetName(playerid));
				mysql_tquery(connection, updatequery);

				format(dstring, sizeof(dstring), "- You congratulations you have just obtained your car license");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				HasGPSBeenDisabled[playerid] = 0;
			}
		}
	}
	if(DrivingTruckCount[playerid] > 0 && DrivingTruckPlayer[playerid] == 1 && IsDrivingVehicle(playerid))
	{
	    new playerVehicleID = GetPlayerVehicleID(playerid);

		if (GetVehicleModel(playerVehicleID) == 456)
		{
		    DisablePlayerCheckpoint(playerid);

            DrivingTruckCount[playerid] ++;

	        new dstring[256];
			format(dstring, sizeof(dstring), "- Your next marker is on your map! (%d/18)", DrivingTruckCount[playerid]-1);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			if(DrivingTruckCount[playerid] == 2) { SetPlayerCheckpoint(playerid, 1355.1953,-1418.6083,12.9861, 5.0); }
			else if(DrivingTruckCount[playerid] == 3) { SetPlayerCheckpoint(playerid, 1271.8380,-1398.6841,12.6198, 5.0); }
			else if(DrivingTruckCount[playerid] == 4) { SetPlayerCheckpoint(playerid, 1211.6638,-1397.8444,12.8466, 5.0); }
			else if(DrivingTruckCount[playerid] == 5) { SetPlayerCheckpoint(playerid, 1199.1884,-1406.5869,12.8528, 5.0); }
			else if(DrivingTruckCount[playerid] == 6) { SetPlayerCheckpoint(playerid, 1194.0056,-1470.3920,12.9802, 5.0); }
			else if(DrivingTruckCount[playerid] == 7) { SetPlayerCheckpoint(playerid, 1199.9183,-1573.2540,12.9779, 5.0); }
			else if(DrivingTruckCount[playerid] == 8) { SetPlayerCheckpoint(playerid, 1272.2620,-1574.9789,12.9782, 5.0); }
			else if(DrivingTruckCount[playerid] == 9) { SetPlayerCheckpoint(playerid, 1294.0011,-1585.9316,12.9782, 5.0); }
			else if(DrivingTruckCount[playerid] == 10) { SetPlayerCheckpoint(playerid, 1299.2527,-1790.5067,12.9785, 5.0); }
			else if(DrivingTruckCount[playerid] == 11) { SetPlayerCheckpoint(playerid, 1304.2068,-1847.6902,12.9778, 5.0); }
			else if(DrivingTruckCount[playerid] == 12) { SetPlayerCheckpoint(playerid, 1309.7480,-1833.2544,12.9788, 5.0); }
			else if(DrivingTruckCount[playerid] == 13) { SetPlayerCheckpoint(playerid, 1310.1819,-1716.8820,12.9803, 5.0); }
			else if(DrivingTruckCount[playerid] == 14) { SetPlayerCheckpoint(playerid, 1310.5149,-1603.0090,12.9803, 5.0); }
			else if(DrivingTruckCount[playerid] == 15) { SetPlayerCheckpoint(playerid, 1314.0156,-1574.5985,12.9786, 5.0); }
			else if(DrivingTruckCount[playerid] == 16) { SetPlayerCheckpoint(playerid, 1343.3987,-1492.9025,12.9881, 5.0); }
			else if(DrivingTruckCount[playerid] == 17) { SetPlayerCheckpoint(playerid, 1362.5438,-1441.2408,13.1347, 5.0); }
			else if(DrivingTruckCount[playerid] == 18) { SetPlayerCheckpoint(playerid, 1376.4298,-1437.6281,13.1409, 5.0); }
			else if(DrivingTruckCount[playerid] == 19)
			{
			    SetVehicleToRespawn(GetPlayerVehicleID(playerid));

			    DrivingTruckPlayer[playerid] = 0;
				DrivingTruckCount[playerid] = 0;

				PlayerData[playerid][Character_License_Truck] = 1;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_truck` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_License_Truck], GetName(playerid));
				mysql_tquery(connection, updatequery);

				format(dstring, sizeof(dstring), "- You congratulations you have just obtained your truck license");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				HasGPSBeenDisabled[playerid] = 0;
			}
		}
	}
	if(TruckJobParcelCount[playerid] < 5 && TruckJobParcelPlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	    
   		TruckJobParcelCount[playerid] ++;
   		
   		PlayerData[playerid][Character_Money] += 500;

        new dstring[256];
		format(dstring, sizeof(dstring), "- Your next local delivery has been marked on your map! (%d/5)", TruckJobParcelCount[playerid]);
		SendClientMessage(playerid, COLOR_YELLOW, dstring);

		new randomNumber = GetValidHouseJobNumber();
		SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 5.0);
	}
	if(TruckJobParcelCount[playerid] == 5 && TruckJobParcelPlayer[playerid] == 1)
	{
   		TruckJobParcelCount[playerid] = 0;
   		TruckJobParcelPlayer[playerid] = 0;

   		PlayerData[playerid][Character_Money] += 500;

        new dstring[256];
		format(dstring, sizeof(dstring), "- You have completed your local parcel deliveries!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring);
		
		HasGPSBeenDisabled[playerid] = 0;
	}
	if(TruckJobMoneyPlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	    
     	TruckJobMoneyPlayer[playerid] = 2;

        new dstring[256];
		format(dstring, sizeof(dstring), "- Drop the money off at the bank!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring);

        SetPlayerCheckpoint(playerid, 997.4561, -1218.0929, 16.5920, 20.0);

		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: ALL UNITS BE ADVISED TRUCKING CO HAS PICKED UP THE MONEY FROM DOCKS)", GetName(playerid));
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);

		print("Truck Money Job Final Phase");
	}
	if(TruckJobMoneyPlayer[playerid] == 2)
	{
	    DisablePlayerCheckpoint(playerid);
	    
     	TruckJobMoneyStarted = 0;
      	TruckJobMoneyPlayer[playerid] = 0;

        new dstring[256];
		format(dstring, sizeof(dstring), "- Congratulations, you have just completed a money drop for the bank! Here is your reward!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring);
		
		HasGPSBeenDisabled[playerid] = 0;
		
		PlayerData[playerid][Character_Money] += 2000;

		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: All Units, Trucking Company has completed their drop off)", GetName(playerid));
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);

		print("Truck Money Job Final Phase");
	}
	if(LSPDJobHouseInpPlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	    
	    LSPDJobHouseInspection = 0;
	    LSPDJobHouseInspectionAccepted = 0;
	    LSPDJobHouseInpPlayer[playerid] = 0;
	
		LSPDJobTimer = 0;
		LSPDJobTimerExp = 0;
	    
	    PlayerData[playerid][Character_Money] += 1500;
	
		new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s has just arrived on scene of the property inspection job)", GetName(playerid));
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);
	    
	    print("LSPD Job Reached");
	}
	if(LSFDJobHouseFirePlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	    
	    LSFDJobHouseFirePlayer[playerid] = 0;
	
		new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s has just arrived on scene of the property fire job)", GetName(playerid));
		SendFactionRadioMessage(2, COLOR_WHITE, dstring);

	    print("LSFD Job Reached");
	}
	if(MechanicJobPlayer[playerid] == 1)
	{
	    DisablePlayerCheckpoint(playerid);
	    
	    new Float:vehx, Float:vehy, Float:vehz;
     	GetVehiclePos(MechanicJobID, vehx, vehy, vehz);

		if(IsPlayerInRangeOfPoint(playerid, 4.0, vehx, vehy, vehz))
		{
		    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, true, false, false, false, 0);
		    
		    Repair_Timer[playerid] = SetTimerEx("RepairTimer", 5000, true, "i", playerid);

		    print("Mechanic Job Reached - Vehicle found");
		}
	}
	if(HasPlayerRobbedAmmunation[playerid] > 0)
	{
	    DisablePlayerCheckpoint(playerid);
	    
	    if(HasPlayerRobbedAmmunationPoint[playerid] == 1)
	    {
	        HasPlayerRobbedAmmunationPoint[playerid] = 2;
	        GivePlayerWeapon(playerid, WEAPON_COLT45, 6);

            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
            
            new string[256];
		    format(string, sizeof(string), "> %s has just removed a pistol from the rack", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

			SetPlayerCheckpoint(playerid, 311.3756, -143.6519, 1004.0547, 2.0);
	    }
	    else if(HasPlayerRobbedAmmunationPoint[playerid] == 2)
	    {
	        HasPlayerRobbedAmmunationPoint[playerid] = 3;
	        SetPlayerAmmo(playerid, WEAPON_COLT45, 24);

            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);

            new string[256];
		    format(string, sizeof(string), "> %s has just removed a few mags from the rack", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

			SetPlayerCheckpoint(playerid, 307.9726, -143.1913, 999.6016, 2.0);
	    }
	    else if(HasPlayerRobbedAmmunationPoint[playerid] == 3)
	    {
	        HasPlayerRobbedAmmunationPoint[playerid] = 0;
	        SetPlayerAmmo(playerid, WEAPON_COLT45, 24);

            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);

            new string[256];
		    format(string, sizeof(string), "> %s has just emptied the cash register", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			
			new amountrobbed;
			amountrobbed = 1 + random(2500);

			PlayerData[playerid][Character_Money] += amountrobbed;

			format(string, sizeof(string), "- You have just stolen $%d.00 worth of money from the vault, get out of there before the cops show up!", amountrobbed);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			
			printf("Ammunation Robbery - Player Has Successfully Robbed The Store");
	    }
	}
    return 1;
}
 
public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}
 
public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}
 
public OnRconCommand(cmd[])
{
    return 1;
}
 
public OnPlayerRequestSpawn(playerid)
{
    return 1;
}
 
public OnObjectMoved(objectid)
{
    return 1;
}
 
public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}
 
public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}
 
public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}
 
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}
 
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}
 
public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}
 
public OnPlayerExitedMenu(playerid)
{
    return 1;
}
 
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    return 1;
}
 
public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    new veh = GetPlayerVehicleID(playerid);
	
	if(IsPlayerInRangeOfPoint(playerid, 5, 1943.48840, -1984.64282, 13.48357) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid) && newkeys == KEY_NO)
	{
		if(VehicleData[veh][Vehicle_Owner] != PlayerData[playerid][Character_Name]) return SendPlayerErrorMessage(playerid, " You do not own this vehicle, you cannot modify it!");
		else
		{
			if(PlayerData[playerid][Character_Money] < 500) return SendPlayerErrorMessage(playerid, " You do not have enough money to purchase a new colour!");
			else
			{ 
				HasPlayerEnteredSprayUnit[playerid] = 1;
				MoveDynamicObject(PaintSprayDoor, 1951.66956, -1984.35400, 13.48357, 2, 0.00000, 0.00000, 0);
				
				SetPlayerCameraPos(playerid, 1937.3737,-1987.0834,15.4767);
				SetPlayerCameraLookAt(playerid, 1944.3542,-1982.2830,13.5469);
				
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(veh, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(veh, false, lights, alarm, doors, bonnet, boot, objective);
				
				//PlayerPlaySound(playerid, 1035, 0.0, 0.0, 0.0);
				
				ShowPlayerDialog(playerid, DIALOG_SPRAY_PAINT, DIALOG_STYLE_LIST, "Cheapo Spray Paints - Select your new vehilce colour", "Black\nWhite\nLight Blue\nDark Blue\nRed\nOrange\nGreen\nGold\nYellow\nNeon Pink\nNeon Purple\nNeon Green", "Preview", "Close");
			}		
		}
	}
	if(IsPlayerInViewState_Binco[playerid] == 1)
	{
		if(newkeys == KEY_SPRINT)
	    {
	  		currentSkinIndex++;
	
		    if (currentSkinIndex > 127) 
			{
		        currentSkinIndex = 0;
		    }
		
		    SetPlayerSkin(playerid, cheapSkins[currentSkinIndex]);
	    }
		if(newkeys == KEY_FIRE)
	    {
	  		if(PlayerData[playerid][Character_Skin_1] > 0 || PlayerData[playerid][Character_Skin_2] > 0 || PlayerData[playerid][Character_Skin_3] > 0)
	        {
	            new option1[256], option2[256], option3[256], options[256];
	            
	            if(PlayerData[playerid][Character_Skin_1] == 0)
	            {
	            	format(option1, sizeof(option1), "Outfit 1 - [Nothing Saved]");
				}
				else if(PlayerData[playerid][Character_Skin_1] != 0)
				{
					format(option1, sizeof(option1), "Outfit 1");
				}
				
				if(PlayerData[playerid][Character_Skin_2] == 0)
	            {
	            	format(option2, sizeof(option2), "Outfit 2 - [Nothing Saved]");
				}
				else if(PlayerData[playerid][Character_Skin_2] != 0)
				{
					format(option2, sizeof(option2), "Outfit 2");
				}
				
				if(PlayerData[playerid][Character_Skin_3] == 0)
	            {
	            	format(option3, sizeof(option3), "Outfit 3 - [Nothing Saved]");
				}
				else if(PlayerData[playerid][Character_Skin_3] != 0)
				{
					format(option3, sizeof(option3), "Outfit 3");
				}
				
				format(options, sizeof(options), "%s\n%s\n%s", option1, option2, option3);
				
				ShowPlayerDialog(playerid, DIALOG_PLAYER_SHOP_SKIN, DIALOG_STYLE_LIST, "Select your clothing slot", options, "Set", "Close");
	        }
		}
		if(newkeys == KEY_AIM)
	    {
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid,true);
			SetPlayerVirtualWorld(playerid, Binco_Current_VW[playerid]);
			
			if(Binco_New_Outfit[playerid] == 1) { SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]); }
			else if(Binco_New_Outfit[playerid] == 2) { SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_2]); }
			else if(Binco_New_Outfit[playerid] == 3) { SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_3]); }
			else if(Binco_New_Outfit[playerid] == 0) { SetPlayerSkin(playerid, Binco_Current_Outfit[playerid]); }
			
			if(GetPlayerSkin(playerid) == 0)
			{
			    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
			}
			
			IsPlayerInViewState_Binco[playerid] = 0;
			Binco_Current_Outfit[playerid] = 0;
			Binco_New_Outfit[playerid] = 0;
			Binco_Current_VW[playerid] = 0;
			currentSkinIndex = 0;
			
			PlayerTextDrawHide(playerid, PlayerText:Store_Textdraw);
		}
    }
    if(newkeys == KEY_SECONDARY_ATTACK)
    {
  		DynamicDoorEntry(playerid);
    }
	if(newkeys == KEY_FIRE && GetPlayerWeapon(playerid) == WEAPON_FIREEXTINGUISHER || newkeys == KEY_FIRE && GetVehicleModel(veh) == 407)
    {
        if(PlayerData[playerid][Character_Faction] == 2 && LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 1)
		{
		    if(LSFDJobHouseFireHealth > 0)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 10.0, HouseData[LSFDJobHouseFireID][House_Outside_X], HouseData[LSFDJobHouseFireID][House_Outside_Y], HouseData[LSFDJobHouseFireID][House_Outside_Z]))
			    {
			        LSFDJobHouseFireHealth -= 10;
			        
			        printf("LSFD Job Fire Health: %d", LSFDJobHouseFireHealth);
			    }
			}
			else if(LSFDJobHouseFireHealth == 0)
			{
			    LSFDJobHouseFire = 0;
			    LSFDJobHouseFireHealth = 0;
			    LSFDJobHouseFireID = 0;

			    DestroyObject(LSFDJobHouseFireObject);
			    DestroyObject(LSFDJobHouseSmokeObject);

			    LSFDJobHouseFireObject = 0;
			    LSFDJobHouseSmokeObject = 0;

			    for (new i = 0; i < MAX_PLAYERS; i++)
				{
					LSFDJobHouseFirePlayer[playerid] = 0;
				}

			    new dstring[256];
				format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The recent property fire has been put out by your team! Well done)");
				SendFactionRadioMessage(2, COLOR_WHITE, dstring);
				
				PlayerData[playerid][Character_Money] += 2500;

				print("LSFD Job Fire Completed");
			}
		}
   	}
	if(newkeys == KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new Float:vehiclehealth;

		GetVehicleHealth(vehicleid, vehiclehealth);
			
		new string[156];
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(engine == 1)
		{
			SetVehicleParamsEx(vehicleid, false, lights, alarm, doors, bonnet, boot, objective);

			format(string, sizeof(string), "> %s has just turned the key of their vehicle off", GetName(playerid));
	   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

   			PlayerTextDrawSetString(playerid, SpeedBoxFuelAmount, "-");

   			KillTimer(Fuel_Timer[playerid]);
   			KillTimer(Vehicle_Timer[playerid]);

   			Fuel_Timer[playerid] = 0;
			Vehicle_Timer[playerid] = 0;

			printf("%s has turned thier vehicle off", GetName(playerid));
		}
		else
		{
		    if(vehiclehealth <= 300) return SendPlayerErrorMessage(playerid, " This vehicle is two damaged to turn on, call a mechanic!");
			else if(vehiclehealth > 300)
			{
			    SetVehicleParamsEx(vehicleid, true, lights, alarm, doors, bonnet, boot, objective);

			    format(string, sizeof(string), "> %s has just turned the key of their vehicle around and turned it on", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

				Fuel_Timer[playerid] = SetTimerEx("FuelTimer", 10000, true);
				Vehicle_Timer[playerid] = SetTimerEx("VehicleTimer", 250, true, "i", playerid);

				printf("%s has turned thier vehicle on", GetName(playerid));
			}
		}
	}
   	if(newkeys == KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
  	{
  	    if(IsTowVehicle(playerid) && PlayerData[playerid][Character_Faction] == 5)
  	    {
		    new playerVehicleID = GetPlayerVehicleID(playerid);

		    if (GetVehicleModel(playerVehicleID) == 525)
			{
		        new Float:pX, Float:pY, Float:pZ;
		        GetPlayerPos(playerid, pX, pY, pZ);

		        //new found = false;

		        for (new vid = 0; vid < MAX_VEHICLES; vid++)
				{
		            if (vid == playerVehicleID) continue;

		            new Float:vX, Float:vY, Float:vZ;
		            GetVehiclePos(vid, vX, vY, vZ);

		            if (floatabs(pX - vX) < 7.0 && floatabs(pY - vY) < 7.0 && floatabs(pZ - vZ) < 7.0)
					{
		                //found = true;

		                if (IsTrailerAttachedToVehicle(playerVehicleID))
						{
		                    DetachTrailerFromVehicle(playerVehicleID);
		                }
						else
						{
		                    AttachTrailerToVehicle(vid, playerVehicleID);

		                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s lowers the arm on the tow vehicle and attaches it to the vehicle behind them", GetName(playerid));

		                    new dstring[256];
		                    format(dstring, sizeof(dstring), "- You have just hooked up a car to your tow vehicle!");
		                    SendClientMessage(playerid, COLOR_YELLOW, dstring);
		                }
		                break;
		            }
		        }
		    }
		}
	}
    return 1;
}
 
public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}
 
public OnPlayerUpdate(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerLogged[playerid])
		{
            CheckUserMoney(playerid);
		}
	}
	
    return 1;
}
 
public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}
 
public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}
 
public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}
 
public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}
 
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
	    case DIALOG_LOGIN:
	    {
	        if(!response) return Kick(playerid);
	        if(strcmp(inputtext, PlayerData[playerid][Character_Password]) == 0)
	        {
	        
	            if(PlayerData[playerid][Character_Registered] == 0)
	            {
	                ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email", "(YOU HAVEN'T COMPLETED YOUR CHARACTER REGISTRATION YET, PLEASE START FROM THE BEGINING)\n\nPlease enter a valid email address\n\n(This email will be used for the future User Control Panel system on the website!)", "Next", "Quit");
	            }
	            else
	            {
		        	IsPlayerLogged[playerid] = 1;

				    TogglePlayerSpectating(playerid, false);

					LoginSpawn(playerid);
				}
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Open Roleplay - Login [Incorrect Password]", "Welcome back, %s!\n\nThis account has been registered before.\n\nPlease enter in the accounts password below:", "Login", "Quit", GetName(playerid));
	        }
	    }
	    case DIALOG_REGISTER:
	    {
	        if(!response) return Kick(playerid);
	        if(strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Open Roleplay - Registration", "(You did not provide a long enough password to continue)\n\nThis account has not been registered before on this server.\n\nPlease enter in a password that you will remember.", "Register", "Quit");
			
			new string[129];
			format(string, sizeof(string), "%s", inputtext);
			PlayerData[playerid][Character_Password] = string;
			
			new query[2000];
	        mysql_format(connection, query, sizeof(query), "INSERT INTO `user_accounts` (`character_name`, `character_password`) VALUES ('%e', '%s')", PlayerData[playerid][Character_Name], PlayerData[playerid][Character_Password]);
			mysql_tquery(connection, query, "OnAccountCreation", "i", playerid);
			
	        ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email", "Please enter a valid email address\n\n(This email will be used for the future User Control Panel system on the website!)", "Next", "Quit");
	    }
	    case DIALOG_REGISTER_EMAIL:
	    {
	   		if(!response) return Kick(playerid);
	        if(!strlen(inputtext)) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email [ERROR]", "(You did not enter any email address)\n\nPlease enter a valid email address\n\n(This email will be used for the future User Control Panel system on the website!)", "Next", "Quit");
			if(strfind(inputtext, "@") == -1) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email [ERROR]", "(You did not enter any email address)\n\nPlease enter a valid email address\n\n(This email will be used for the future User Control Panel system on the website!)", "Next", "Quit");

			else
			{
			    new IPValue[16];
            	PlayerData[playerid][Account_IP] = GetPlayerIp(playerid, IPValue, sizeof(IPValue));
            	
            	new string[129];
				format(string, sizeof(string), "%s", inputtext);
				PlayerData[playerid][Account_Email] = string;
            
	        	ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Character Creation - Age", "Please set your new characters in-game age:", "Next", "Quit");
			}
		}
	    case DIALOG_REGISTER_AGE:
	    {
	    	if(!response) return Kick(playerid);
	        if(!strlen(inputtext)) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Character Creation - Age [ERROR]", "Please set your new characters in-game age:\n\n\n(You did not provide any numerical value)", "Next", "Quit");
			if(strval(inputtext) > 90 || strval(inputtext) < 16) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Character Creation - Age [ERROR]", "Please set your new characters in-game age:\n\n\n(You need to pick an age between 16 and 90)", "Next", "Quit");

            PlayerData[playerid][Character_Age] = strval(inputtext);

	        ShowPlayerDialog(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "Character Creation - Sex", "Male\nFemale\nNon-Binary\nTransgender\nGhost", "Next", "Quit");
	    }
	    case DIALOG_REGISTER_SEX:
	    {
	    	if(!response) return Kick(playerid);
			if(response)
			{
			    new stext[126];
			    
			    switch(listitem)
			    {
			        case 0: { stext = "Male"; SetPlayerSkin(playerid, 3); }
			        case 1: { stext = "Female"; SetPlayerSkin(playerid, 41); }
		         	case 2: { stext = "Non-Binary"; SetPlayerSkin(playerid, 3); }
			        case 3: { stext = "Transgender"; SetPlayerSkin(playerid, 40); }
			        case 4: { stext = "Ghost"; SetPlayerSkin(playerid, 167); }
			    }
			    
			    PlayerData[playerid][Character_Skin_1] = GetPlayerSkin(playerid);
			    
			    new string[129];
				format(string, sizeof(string), "%s", stext);
				PlayerData[playerid][Character_Sex] = string;
                
	        	ShowPlayerDialog(playerid, DIALOG_REGISTER_BP, DIALOG_STYLE_LIST, "Character Creation - Birthplace", "Los Santos\nLiberty City\nVice City\nUnknown", "Complete", "Quit");
			}
		}
	    case DIALOG_REGISTER_BP:
	    {
	    	if(!response) return Kick(playerid);

			if(response)
			{
			    new stext[126];
			    switch(listitem)
			    {
			        case 0: { stext = "Los Santos"; }
			        case 1: { stext = "Liberty City"; }
			        case 2: { stext = "Vice City"; }
			        case 3: { stext = "Unknown"; }
			    }
			    
			    new string[129];
				format(string, sizeof(string), "%s", stext);
				PlayerData[playerid][Character_Birthplace] = string;
				
				PlayerData[playerid][Character_Registered] = 1;

	        	ShowPlayerDialog(playerid, DIALOG_REGISTER_END, DIALOG_STYLE_MSGBOX, "Character Creation - Complete", "Thank you for creating a new character and welcome to our community.\n\nYou are about to land at our airport, please make sure you look at our guides", "Close", "");
			}

     	}
	    case DIALOG_REGISTER_END:
	    {
	        new acquery[2000];
	        mysql_format(connection, acquery, sizeof(acquery), "UPDATE `user_accounts` SET `account_email` = '%s', `character_registered` = '%i', `character_age` = '%i',`character_sex` = '%s',`character_birthplace` ='%s', `character_skin_1` ='%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Account_Email], PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Skin_1], PlayerData[playerid][Character_Name]);
    		mysql_tquery(connection, acquery);

			TogglePlayerSpectating(playerid, false);
	        
	        ClearMessages(playerid);
	        
	        RegistrationSpawn(playerid);
	    }
		case DIALOG_GUIDE_LIST:
		{
		    if(!response) return 1;
		    
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: { ShowPlayerDialog(playerid, DIALOG_GUIDE_JOBS, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Jobs", "This server holds an array of jobs to chose from. Once you gain a mobile phone from any eletronic store, you can\nuse your device to locate these jobs.\n\nSome of the local jobs are:\n> Detective\n> Rubbish Collector\n> Pizza Delivery\n> Farmer\n> Parking Warden\n\nIf you require any help in obtaining a job, please reach out to the staff team by using /assistance)", "Close", ""); }
		            case 1: { ShowPlayerDialog(playerid, DIALOG_GUIDE_FACTIONS, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Factions", "This server holds many different types of factions. You don't need to join on a forum anymore, simply\napply in game (/joinfaction).\n\nSome of the local factions are:\n> LSPD\n> LSFD\n> LSMC\n> Mechanic\n> Trucking\n> LS Bank\n\nIf you require any help in obtaining a faction position, please reach out to the staff team by using /assistance)", "Close", ""); }
		            case 2: { ShowPlayerDialog(playerid, DIALOG_GUIDE_COMMANDS, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Commands", "There are alot of commands for this server, due to the ammount you can view these all by typing /commands\n\nStarting roleplay commands are:\n\n1. /me - roleplay the actions of the user\n2. /do - asks the response of the action or result of the said action\n3. /ooc - local out of character chat\n4. /global - server network public chat for all users to communicate out of character wise", "Close", ""); }
		            case 3: { ShowPlayerDialog(playerid, DIALOG_GUIDE_VEHICLES, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Vehicles", "Within this server we have standard vehicles placed throughout the city to help with daily life. Sadly,\nthese vehicles are not player owned and if pulled over in one could get you arrested.\n\nYou can buy or rent vehicles from our local dealerships, these can be found with the GPS system\nwithin your cellphone.", "Close", ""); }
		            case 4: { ShowPlayerDialog(playerid, DIALOG_GUIDE_HOUSES, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Houses", "We have many features within this server and houses for players to buy is one of them.\n\nThere are currently 200 houses within the server and all are custom built with either basic interiors or custom mapped ones depending on location.\nIf you want to view a house, all you need to do is, go up to a green pickup icon and type /buyproperty\n\nYou can also sell your property by standing next to your hosue and typing /sellproperty", "Close", ""); }
		            case 5: { ShowPlayerDialog(playerid, DIALOG_GUIDE_ADMINS, DIALOG_STYLE_MSGBOX, "Open Roleplay Guide - Admins", "Due to we are in early stages of development, this project will host many types of admins from different locations.\n\nPlease take note that this is volunteer basis and noone is getting paid to be here. Please respect all admins\nand staff while in game and have a great time on our server.", "Close", ""); }
		        }
		    }
		}
		case DIALOG_COMMANDS_MAIN:
		{
		    if(!response) return 1;
		    if(response)
		    {
			    new titlestring[256], dialogstring[1500], dialogstring1[250], dialogstring2[250], dialogstring3[250];
			    switch(listitem)
			    {
					case 0:
					{
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Generic Commands ***");
      					SendClientMessage(playerid, COLOR_YELLOW, "Community:{FFFFFF} /staff /helpme /assistance /report /commands /guide /time");
						SendClientMessage(playerid, COLOR_YELLOW, "Chat:{FFFFFF} /w(hisper) /s(hout) /o(oc) /g(lobal) /clearchat /radio(r) /pm");
						SendClientMessage(playerid, COLOR_YELLOW, "Phone:{FFFFFF} /phonebook /phonenumber /togglephone /call /pickup /endcall /gps /cancelgps");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /me /do /stats /pay /paybill /bills /billcustomer /acceptdeath");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /getlicense /licenses /showlicenses /pockets /change /shop /tie");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rappel /hack /rob /hw(hotwire) /lockpick /gate /bankaccount /smuggle /bake /usedrugs");
						SendClientMessage(playerid, COLOR_YELLOW, "Vehicle:{FFFFFF} /engine /lights /bonnet /boot /rentcar /unrentcar /fillup /recyclecar /changeownership /park /flash");
						SendClientMessage(playerid, COLOR_YELLOW, "Faction:{FFFFFF} /joinfaction /cancelrequest");
						SendClientMessage(playerid, COLOR_YELLOW, "Misc:{FFFFFF} /buyfaction /sellfaction /rent /unrent");
					}
			        case 1:
					{
					    if(PlayerData[playerid][Character_Faction] == 0)
					    {
					        format(titlestring, sizeof(titlestring), "*** Open Roleplay Faction Commands ***");
							format(dialogstring1, sizeof(dialogstring1), "You are currently not apart of any faction in this server!\n\nYou can join a faction by locating the faction [i] icon and typing");
							format(dialogstring2, sizeof(dialogstring2), "\n/joinfaction or applying through the forums!");
							format(dialogstring3, sizeof(dialogstring3), "\n\nWe have attempted to keep this server user friendly by allowing ingame and forums faction applications.");

							format(dialogstring, sizeof(dialogstring), "%s%s%s", dialogstring1, dialogstring2, dialogstring3);
							ShowPlayerDialog(playerid, DIALOG_COMMANDS_FACTION, DIALOG_STYLE_MSGBOX, titlestring, dialogstring, "Close", "");
					    }
					    else if(PlayerData[playerid][Character_Faction] == 1)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSPD)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /search /cancelbackup(cbu) /backup(bu) /mdc /ticket /arrest /placeincar(pic)");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /cuff /taser /acceptjob /canceljob /acceptcall /drag");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSPD)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /search /cancelbackup(cbu) /backup(bu) /mdc /ticket /arrest /placeincar(pic)");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /cuff /taser /acceptjob /canceljob /acceptcall /drag");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest /issuelicense");
							}
					    }
					    else if(PlayerData[playerid][Character_Faction] == 2)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSFD)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /fireex /acceptjob /canceljob /acceptcall");
							}
							else
							{
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSFD)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /fireex /acceptjob /canceljob /acceptcall");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 3)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSMC)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /drag /heal /placeincar(pic)");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSMC)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /megaphone /duty /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /drag /heal /placeincar(pic)");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 4)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LS Bank)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /computer /funds");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LS Bank)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /computer /funds");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
					    else if(PlayerData[playerid][Character_Faction] == 5)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
					            SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Tow Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Tow Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /gr(adio) /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 6)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Taxi Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Taxi Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 7)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Truck Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Truck Co)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
					    else if(PlayerData[playerid][Character_Faction] == 8)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
					            SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Dudefix)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /duty /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptjob /canceljob /shovel /fixpipe");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Dudefix)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /duty /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptjob /canceljob /shovel /fixpipe");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
					    else if(PlayerData[playerid][Character_Faction] == 9)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
					            SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Mechanic)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /acceptjob /canceljob /tools /checkgear /fix /fillvehicle");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Mechanic)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /duty /joinfaction /quitfaction /gate");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /acceptjob /canceljob /tools /checkgear /fix /fillvehicle");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 10)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Grove Street Gang)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Grove Street Gang)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 11)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (La Familia)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (La Familia)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 12)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hells Angels Gang)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hells Angels Gang)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
						else if(PlayerData[playerid][Character_Faction] == 13)
					    {
					        if(PlayerData[playerid][Character_Faction_Rank] != 6)
					        {
		        				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hendrix Crime Familia)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
							}
							else
							{						
								SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hendrix Crime Familia)***");
						        SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(factionradio) /fchat(factionchat) /fstaff /joinfaction /quitfaction");
						        SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
								SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
							}
					    }
					}
			        case 2:
					{
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay House Commands ***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /buyproperty /sellproperty");
					}
			        case 3:
					{
					    SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Business Commands ***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /buybusiness /sellbusiness");
					}
			        case 4:
					{						
						if(PlayerData[playerid][Character_Job] == 1)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Pizza Delivery)***");
						    SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
						    SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
					    }
						else if(PlayerData[playerid][Character_Job] == 2)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Garbage Collector)***");
						    SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
						    SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
					    }
						else if(PlayerData[playerid][Character_Job] == 3)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Electrician)***");
						    SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
						    SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob /flash");
					    }
						else return SendPlayerErrorMessage(playerid, " You are not apart of any job company at this point in time!");
					}
			        case 5:
					{
						if(PlayerData[playerid][Helper_Level] == 1)
					    {
							SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
					    }
						else if(PlayerData[playerid][Moderator_Level] == 1)
					    {
							SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 1)
					    {
							SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 2)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /getplayer /gotoplayer /unmute /mute /sethealth");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 3)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /getplayer /gotoplayer /unmute /mute /sethealth");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 4)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /getplayer /gotoplayer /unmute /mute /sethealth");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 5)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /getplayer /gotoplayer /unmute /mute /sethealth");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /giveweapon /starttornado /stoptornado /givecoins");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /vinfo /vdelete /vcreate /vpark /vremoveowner /vsetowner /vremovefaction /vsetfaction /vsetjob /vtype");
					    }
					    else if(PlayerData[playerid][Admin_Level] == 6)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
							SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap /playertype /freeze /unfreeze");
							SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /getplayer /gotoplayer /unmute /mute /sethealth");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /giveweapon /starttornado /stoptornado /givecoins");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /vinfo /vdelete /vcreate /vpark /vremoveowner /vsetowner /vremovefaction /vsetfaction /vsetjob /vtype");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /fnext /finfo /ficonpos /fsetcost /fsettype /fsetowner /fremoveowner /fname /frankname /fdelete");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /ddnext /ddinfo /ddname /ddfaction //ddedit /dddelete");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /hnext /hinfo /hedit /hpreset /hdelete /hsetaddress /hsetcost /hsetowner /hremoveowner");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /bnext /binfo /bedit /bdelete /bsetname /bsetcost /bsettype /bsetowner /bremoveowner");
							SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /setleader /sethelper /setmoderator /setadmin /gmx /givecoins /globalchat");
					    }
					}
			    }
			}
		}
		case DIALOG_PLAYER_STATS:
  		{
  		    if(!response) return 1;
  		    else
  		    {
	  		    new titlestring[100], dialogstring[2000];

	  		    format(titlestring, sizeof(titlestring), "%s Statistics (In-Game)", GetName(playerid));
				format(dialogstring, sizeof(dialogstring), " Coins: \t%i\n Money: \t$%i\n Bank: \t$%d\n\n Houses: \t%d/2\n Vehicles: \t%d/2\n Businesses: \t%d/2", PlayerData[playerid][Character_Coins], PlayerData[playerid][Character_Money], PlayerData[playerid][Character_Bank_Money], PlayerData[playerid][Character_Total_Houses], PlayerData[playerid][Character_Total_Vehicles], PlayerData[playerid][Character_Total_Businesses]);
		        ShowPlayerDialog(playerid, DIALOG_PLAYER_STATS_MORE, DIALOG_STYLE_TABLIST, titlestring, dialogstring, "Prev", "Close");
			}
	        
  		}
		case DIALOG_PLAYER_STATS_MORE:
		{
		    if(!response) return 1;
  		    else
  		    {
  		        new titlestring[100], dialogstring[2000], staffname[50];
				new fstring[20], frankstring[20], jstring[50];
				new factionid;
		
				if(PlayerData[playerid][Helper_Level] == 1) { format(staffname, sizeof(staffname), "Helper"); }
				else if(PlayerData[playerid][Moderator_Level] == 1) { format(staffname, sizeof(staffname), "Moderator"); }
				else if(PlayerData[playerid][Admin_Level] == 1) { format(staffname, sizeof(staffname), "Admin - Level 1"); }
				else if(PlayerData[playerid][Admin_Level] == 2) { format(staffname, sizeof(staffname), "Admin - Level 2"); }
				else if(PlayerData[playerid][Admin_Level] == 3) { format(staffname, sizeof(staffname), "Admin - Level 3"); }
				else if(PlayerData[playerid][Admin_Level] == 4) { format(staffname, sizeof(staffname), "Admin - Level 4"); }
				else if(PlayerData[playerid][Admin_Level] == 5) { format(staffname, sizeof(staffname), "Admin - Level 5"); }
				else if(PlayerData[playerid][Admin_Level] == 6) { format(staffname, sizeof(staffname), "Admin - Level 6"); }
	
				factionid = PlayerData[playerid][Character_Faction];
	
				if(PlayerData[playerid][Character_Faction] == 0)
				{
					fstring = "None";
				}
				else
				{
					format(fstring, sizeof(fstring), "%s", FactionData[factionid][Faction_Name]);
				}
	
				switch(PlayerData[playerid][Character_Faction_Rank])
				{
					case 0: { format(frankstring, sizeof(frankstring), "None"); }
					case 1: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_1]); }
					case 2: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_2]); }
					case 3: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_3]); }
					case 4: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_4]); }
					case 5: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_5]); }
					case 6: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_6]); }
				}
					
				switch(PlayerData[playerid][Character_Job])
				{
					case 0: { format(jstring, sizeof(jstring), "None"); }
					case 1: { format(jstring, sizeof(jstring), "Pizza Delivery"); }
					case 2: { format(jstring, sizeof(jstring), "Garbage Collector"); }
				}
		        
		        format(titlestring, sizeof(titlestring), "%s Statistics (In-Game)", GetName(playerid));
				format(dialogstring, sizeof(dialogstring), " Character Name: \t%s\n Character Age: \t%i\n Character Sex: \t%s\n Character Birthplace: \t%s\n\n Character Level: \t%i\n Character Exp: \t%i/8\n Staff Level: \t%s\n Faction: \t%s\n Faction Rank: \t%s\n Job: \t%s", PlayerData[playerid][Character_Name], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace],PlayerData[playerid][Character_Level] , PlayerData[playerid][Character_Level_Exp], staffname, fstring, frankstring, jstring);
		        ShowPlayerDialog(playerid, DIALOG_PLAYER_STATS, DIALOG_STYLE_TABLIST, titlestring, dialogstring, "More", "Close");
  		    }
		}
		case DIALOG_BANK_LOGIN:
	    {
	        if(!response) return 1;
	        if(strcmp(inputtext, PlayerData[playerid][Character_Bank_Pin]) == 0)
	        {
             	ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_LOGIN, DIALOG_STYLE_PASSWORD, "Los Santos Bank", "(INCORRECT PASSWORD!)\n\nWelcome back to the Los Santos Bank!\n\nPlease enter in the password you used to set the account up.", "Login", "Close");
	        }
	    }
	    case DIALOG_BANK_REGISTER:
	    {
	        if(!response) return 1;
	        if(strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_BANK_REGISTER, DIALOG_STYLE_PASSWORD, "Los Santos Bank", "(PASSWORD TOO SHORT!)\n\nIt appears that you do not have an open account with us!\n\nPlease enter in a password below that you want to use for this account.\n\n(There will be a $100 fee to the end user for the cost of setting the account up)", "Register", "Close");

			new string[129];
			format(string, sizeof(string), "%s", inputtext);
			PlayerData[playerid][Character_Bank_Pin] = string;
			PlayerData[playerid][Character_Bank_Account] = 1;
			
			PlayerData[playerid][Character_Money] += -100;
			
			new dstring[256];
			format(dstring, sizeof(dstring), "[BANK]:{FFFFFF} Thank you for opening a new account with us. We have taken a $100 fee for set up costs!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			new bankquery[2000];
	        mysql_format(connection, bankquery, sizeof(bankquery), "UPDATE `user_accounts` SET `character_bank_account` = '1', `character_bank_pin` = '%s' WHERE `character_name` = '%e' LIMIT 1", string, PlayerData[playerid][Character_Name]);
    		mysql_tquery(connection, bankquery);

	        ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	    }
	    case DIALOG_BANK_MENU:
	    {
			if(!response) return 1;
			else
			{
		        switch(listitem)
		        {
		            case 0:
		            {
		                new bodytext[256];
		                format(bodytext, sizeof(bodytext), "Balance: $%d\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

						ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
		            }
		            case 1:
		            {
	                    new bodytext[256];
		                format(bodytext, sizeof(bodytext), "New Application\nExisting Applications");

						ShowPlayerDialog(playerid, DIALOG_BANK_BUSINESS, DIALOG_STYLE_LIST, "Bank Account - Loans", bodytext, "Select", "Go Back");
		            }
		            case 2:
		            {
	                    new bodytext[256];
		                format(bodytext, sizeof(bodytext), "You are about to close your bank accounnt!\n\nAre you sure that you want to continue?\nAll money will be transferred to your on person wallet!");

						ShowPlayerDialog(playerid, DIALOG_BANK_CLOSE, DIALOG_STYLE_MSGBOX, "Bank Account - Close Of Account", bodytext, "Confirm", "Go Back");
		            }
		        }
			}
	    }
	    case DIALOG_BANK_ACCOUNT:
	    {
         	if(!response) return ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        switch(listitem)
	        {
	            case 0:
				{
				    new bodytext[256];
	                format(bodytext, sizeof(bodytext), "Balance: $%i\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

					ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
	            }
	            case 1:
	            {
	                ShowPlayerDialog(playerid, DIALOG_BANK_AWITHDRAW, DIALOG_STYLE_INPUT, "Bank Account - Withdraw", "Please enter in the amount that you would like to withdraw:", "Withdraw", "Go Back");
	            }
	            case 2:
	            {
	                ShowPlayerDialog(playerid, DIALOG_BANK_ADEPOSIT, DIALOG_STYLE_INPUT, "Bank Account - Deposit", "Please enter in the amount that you would like to deposit into your account:", "Deposit", "Go Back");
	            }
	        }
	    }
	    case DIALOG_BANK_AWITHDRAW:
	    {
	        if(!response)
	        {
                new bodytext[256];
                format(bodytext, sizeof(bodytext), "Balance: $%i\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

				ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
	        }
	        else
	        {
	            if(strval(inputtext) > PlayerData[playerid][Character_Bank_Money])
		        {
		            ShowPlayerDialog(playerid, DIALOG_BANK_AWITHDRAW, DIALOG_STYLE_INPUT, "Bank Account - Withdraw", "(ERROR - You cannot request more than what you have in your account!)\n\nPlease enter in the amount that you would like to withdraw:", "Withdraw", "Go Back");
		        }
		        else if(strval(inputtext) < 0)
		        {
		            ShowPlayerDialog(playerid, DIALOG_BANK_AWITHDRAW, DIALOG_STYLE_INPUT, "Bank Account - Withdraw", "(ERROR - You cannot withdraw negative amount from the bank!)\n\nPlease enter in the amount that you would like to withdraw:", "Withdraw", "Go Back");
		        }
		        else
		        {
		            PlayerData[playerid][Character_Money] += strval(inputtext);
		            PlayerData[playerid][Character_Bank_Money] -= strval(inputtext);
		            
		            new bankquery[2000];
			        mysql_format(connection, bankquery, sizeof(bankquery), "UPDATE `user_accounts` SET `character_bank_money` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Bank_Money], GetName(playerid));
		    		mysql_tquery(connection, bankquery);
		            
		            new dstring[256];
					format(dstring, sizeof(dstring), "[BANK]:{FFFFFF} You have just withdrawn $%i, out of your bank account!", strval(inputtext));
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
					
					new bodytext[256];
	                format(bodytext, sizeof(bodytext), "Balance: $%i\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

					ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
		        }
			}
	    }
	    case DIALOG_BANK_ADEPOSIT:
	    {
	        if(!response)
	        {
                new bodytext[256];
                format(bodytext, sizeof(bodytext), "Balance: $%i\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

				ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
	        }
	        else
	        {
	            if(strval(inputtext) > PlayerData[playerid][Character_Money])
		        {
		            ShowPlayerDialog(playerid, DIALOG_BANK_ADEPOSIT, DIALOG_STYLE_INPUT, "Bank Account - Deposit", "(ERROR - You cannot deposit more than what you have in your wallet!)\n\nPlease enter in the amount that you would like to deposit:", "Deposit", "Go Back");
		        }
		        else if(strval(inputtext) < 0)
		        {
		            ShowPlayerDialog(playerid, DIALOG_BANK_ADEPOSIT, DIALOG_STYLE_INPUT, "Bank Account - Deposit", "(ERROR - You cannot deposit negative amounts into the bank!)\n\nPlease enter in the amount that you would like to deposit:", "Deposit", "Go Back");
		        }
		        else
		        {
		            PlayerData[playerid][Character_Money] -= strval(inputtext);
		            PlayerData[playerid][Character_Bank_Money] += strval(inputtext);
		            
		            new bankquery[2000];
			        mysql_format(connection, bankquery, sizeof(bankquery), "UPDATE `user_accounts` SET `character_bank_money` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Bank_Money], GetName(playerid));
		    		mysql_tquery(connection, bankquery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[BANK]:{FFFFFF} You have just deposited $%i, into your bank account!", strval(inputtext));
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
					
					new bodytext[256];
	                format(bodytext, sizeof(bodytext), "Balance: $%i\n1.\tWithdraw\n2.\tDeposit", PlayerData[playerid][Character_Bank_Money]);

					ShowPlayerDialog(playerid, DIALOG_BANK_ACCOUNT, DIALOG_STYLE_LIST, "Bank Account - Personal", bodytext, "Select", "Go Back");
		        }
			}
	    }
	    case DIALOG_BANK_CLOSE:
	    {
	        if(!response)
	        {
                ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	    		PlayerData[playerid][Character_Bank_Account] = 0;
	    		PlayerData[playerid][Character_Bank_Pin] = 0;

	    		PlayerData[playerid][Character_Money] += PlayerData[playerid][Character_Bank_Money];
	    		PlayerData[playerid][Character_Bank_Money] = 0;

	    		new bankquery[2000];
		        mysql_format(connection, bankquery, sizeof(bankquery), "UPDATE `user_accounts` SET `character_bank_account` = '0', `character_bank_pin` = '0', `character_bank_money` = '0' WHERE `character_name` = '%e' LIMIT 1", GetName(playerid));
	    		mysql_tquery(connection, bankquery);

	    		new dstring[256];
				format(dstring, sizeof(dstring), "[BANK]:{FFFFFF} You have just closed your bank account and your saved money has been added to your wallet!");
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
			}
	    }
	    case DIALOG_BANK_FAC_LOGIN:
	    {
	        if(!response) return 1;
	        if(strcmp(inputtext, "1111") == 0)
	        {
             	new query[128];
			    mysql_format(connection, query, sizeof(query), "SELECT * FROM `loan_information` WHERE `loan_status` = '0'");
				mysql_tquery(connection, query, "OnLoanCheck", "i", playerid);
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_FAC_LOGIN, DIALOG_STYLE_PASSWORD, "Los Santos Bank - Computer (Invalid Credentials)", "Welcome to the Los Santos Bank Computer System\n\nThis system is where you will be able to review requested loans.\n\nPlease enter in your work password:", "Login", "Close");
	        }
	    }
	    case DIALOG_BANK_FAC_LOANS:
	    {
	        if(!response)
	        {
	            SelectedLoanID[playerid] = 0;
	            SelectedLoanAmount[playerid] = 0;
	            
	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;
	        }
			else
	        {
	            SelectedLoanID[playerid] = SQL_LOAN_ID[playerid][listitem];
	            SelectedLoanAmount[playerid] = SQL_LOAN_AMOUNT[playerid][listitem];
	            
	            new query[128];
			    mysql_format(connection, query, sizeof(query), "SELECT * FROM `loan_information` WHERE `loan_id` = %d", SelectedLoanID);
			    mysql_tquery(connection, query, "OnLoanDetails", "i", playerid);
	        }
	    }
	    case DIALOG_BANK_FAC_LOAN_INFO:
	    {
	        if(!response)
	        {
             	SelectedLoanID[playerid] = 0;
	            SelectedLoanAmount[playerid] = 0;

	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;
	            
	            new query[128];
			    mysql_format(connection, query, sizeof(query), "SELECT * FROM `loan_information` WHERE `loan_status` = '0'");
				mysql_tquery(connection, query, "OnLoanCheck", "i", playerid);
	        }
			else
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_FAC_LOAN_STAT, DIALOG_STYLE_LIST, "Los Santos Bank - Loan Status", "1. Approve Loan\n2. Reject Loan", "Select", "Go Back");
	        }
	    }
	    case DIALOG_BANK_FAC_LOAN_STAT:
	    {
	        if(!response)
	        {
             	SelectedLoanID[playerid] = 0;
	            SelectedLoanAmount[playerid] = 0;

	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;

	            new query[128];
			    mysql_format(connection, query, sizeof(query), "SELECT * FROM `loan_information` WHERE `loan_status` = '0'");
				mysql_tquery(connection, query, "OnLoanCheck", "i", playerid);
	        }
			else
	        {
	            switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Faction] == 4 && FactionData[4][Faction_Money] >= SelectedLoanAmount[playerid])
						{
				    		new acquery[2000];
				        	mysql_format(connection, acquery, sizeof(acquery), "UPDATE `loan_information` SET `loan_status` = '1' WHERE `loan_id` = '%d' LIMIT 1", SelectedLoanID[playerid]);
				        	mysql_tquery(connection, acquery);

				            ShowPlayerDialog(playerid, DIALOG_BANK_FAC_APPROVAL, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Loan Approval", "You have just approved a loan.\n\nTo transfer the funds to the bank account, click 'Transfer'", "Transfer", "Close");
						}
						else
						{
						    SelectedLoanID[playerid] = 0;
				            SelectedLoanAmount[playerid] = 0;

				            new name[50];
				            format(name, sizeof(name), "0");
				            SelectedLoanName[playerid] = name;
	            
						    ShowPlayerDialog(playerid, DIALOG_BANK_FAC_REJECTION, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Lending Power", "You have loaned out too much money this week, please wait for your stock to increase", "Close", "");
						}
		            }
		            case 1:
		            {
	                    new acquery[2000];
      					mysql_format(connection, acquery, sizeof(acquery), "UPDATE `loan_information` SET `loan_status` = '2' WHERE `loan_id` = '%d' LIMIT 1", SelectedLoanID[playerid]);
				    	mysql_tquery(connection, acquery);

         				SelectedLoanID[playerid] = 0;
			            SelectedLoanAmount[playerid] = 0;

			            new name[50];
			            format(name, sizeof(name), "0");
			            SelectedLoanName[playerid] = name;
			            
			            ShowPlayerDialog(playerid, DIALOG_BANK_FAC_REJECTION, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Loan Rejection", "You have just rejected a loan.\n\nPlease make contact with the customer to inform them of their loss", "Close", "");
		            }
		        }
	        }
	    }
	    case DIALOG_BANK_FAC_APPROVAL:
	    {
	        if(!response)
	        {
             	SelectedLoanID[playerid] = 0;
	            SelectedLoanAmount[playerid] = 0;

	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;
	        }
			else
	        {
	            new uquery[2000];
        		mysql_format(connection, uquery, sizeof(uquery), "UPDATE `user_accounts` SET `character_bank_loan` = '0', `character_bank_money` = `character_bank_money` + %d WHERE `character_name` = '%s' LIMIT 1", SelectedLoanAmount[playerid], SelectedLoanName[playerid]);
				mysql_tquery(connection, uquery);
				
				ShowPlayerDialog(playerid, DIALOG_BANK_FAC_END, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Transfered Funds", "You have just transfered the funds.", "Close", "");
	        }
	    }
	    case DIALOG_BANK_FAC_END:
	    {
	        if(!response)
	        {
	            FactionData[4][Faction_Money] -= SelectedLoanAmount[playerid];
	            
	            new fquery[2000];
        		mysql_format(connection, fquery, sizeof(fquery), "UPDATE `faction_information` SET `faction_money` = `faction_money` - %d WHERE `faction_id` = '4' LIMIT 1", SelectedLoanAmount[playerid]);
				mysql_tquery(connection, fquery);
				
	            SelectedLoanID[playerid] = 0;
  				SelectedLoanAmount[playerid] = 0;

	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;
	        }
	        else
	        {
	            FactionData[4][Faction_Money] -= SelectedLoanAmount[playerid];
	            
	            new fquery[2000];
        		mysql_format(connection, fquery, sizeof(fquery), "UPDATE `faction_information` SET `faction_money` = `faction_money` - %d WHERE `faction_id` = '4' LIMIT 1", SelectedLoanAmount[playerid]);
				mysql_tquery(connection, fquery);
				
	            SelectedLoanID[playerid] = 0;
  				SelectedLoanAmount[playerid] = 0;

	            new name[50];
	            format(name, sizeof(name), "0");
	            SelectedLoanName[playerid] = name;
	        }
	    }
	    case DIALOG_BANK_VIEW_LOANS:
	    {
	        if(!response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	    }
	    case DIALOG_BANK_BUSINESS:
	    {
	        if(!response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	            switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Bank_Loan] == 1)
						{
						    ShowPlayerDialog(playerid, DIALOG_BANK_FAC_REJECTION, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Existing Application", "You already have an existing application open, please wait before applying again or speak to the bank!", "Close", "");
						}
						else
						{
						    ShowPlayerDialog(playerid, DIALOG_BANK_LOAN_AMOUNT, DIALOG_STYLE_INPUT, "Los Santos Bank - Application", "Please enter in the amount you would like to borrow:\n\n(Please remember to be realistic or they might deny your application)", "Next", "Go Back");
						}
					}
					case 1:
					{
					    new cquery[128];
					    mysql_format(connection, cquery, sizeof(cquery), "SELECT * FROM `loan_information` WHERE `loan_status` = '0' AND `loan_name` = '%e'", GetName(playerid));
						mysql_tquery(connection, cquery, "OnLoanCheckCustomer", "i", playerid);
					}
				}
	        }
	    }
	    case DIALOG_BANK_LOAN_AMOUNT:
	    {
	        if(!response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	           	ApplicationLoanAmount[playerid] = strval(inputtext);
	            
	            ShowPlayerDialog(playerid, DIALOG_BANK_LOAN_REASON, DIALOG_STYLE_INPUT, "Los Santos Bank - Application", "Please enter in a reason for your loan:", "Submit", "Go Back");
	        }
	    }
	    case DIALOG_BANK_LOAN_REASON:
	    {
	        if(!response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Los Santos Bank", "Account Information\nLoan Information\nClose Bank Account", "Select", "Close");
	        }
	        else
	        {
	            new string[50], Reason[50];
				format(string, sizeof(string), "%s", inputtext);
				Reason = string;

                new query[128];
				mysql_format(connection, query, sizeof(query), "INSERT INTO `loan_information` (`loan_name`, `loan_amount`, `loan_reason`) VALUES ('%s', '%d', '%s')", GetName(playerid), ApplicationLoanAmount[playerid], Reason);
				mysql_tquery(connection, query);
				
				PlayerData[playerid][Character_Bank_Loan] = 1;

	            ShowPlayerDialog(playerid, DIALOG_BANK_LOAN_SUBM, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Submitted Application", "Thank you for submitting a loan application.\n\nThe staff of the bank will review this loan shortly", "Close", "");
	        }
	    }
	    case DIALOG_MDC_MENU:
	    {
			if(!response) return 1;
			else
			{
		        switch(listitem)
		        {
		            case 0:
		            {
		                new bodytext[256];
		                format(bodytext, sizeof(bodytext), "Please enter in the player name that you need to check: (Firstname_Lastname)");

						ShowPlayerDialog(playerid, DIALOG_MDC_PLAYER_SEARCH, DIALOG_STYLE_INPUT, "MDC - Player Search", bodytext, "Search", "Go Back");
		            }
		            case 1:
		            {
	                    new bodytext[256];
		                format(bodytext, sizeof(bodytext), "Please enter in the license plate number of the vehicle: (ORP 001)");

						ShowPlayerDialog(playerid, DIALOG_MDC_VEHICLE_SEARCH, DIALOG_STYLE_INPUT, "MDC - Vehicle Search", bodytext, "Search", "Go Back");
		            }
		        }
			}
	    }
	    case DIALOG_MDC_PLAYER_SEARCH:
	    {
	        if(!response) return ShowPlayerDialog(playerid, DIALOG_MDC_MENU, DIALOG_STYLE_LIST, "Los Santos Government - MDC", "Search Player Records\nSearch Vehicle Records", "Select", "Close");
			else
			{
			    new foundPlayer = false;
			    
			    for(new i = 0; i < MAX_PLAYERS; i++)
				{
				    if(strcmp(inputtext, PlayerData[i][Character_Name]) == 0)
					{
					    new lastcrimestring[50], lastjailedstring[50];
					    new L1[20], L2[20], L3[20], L4[20], L5[20], L6[20];
					    
					    if(strlen(PlayerData[i][Character_Last_Crime]) == 0) { format(lastcrimestring, sizeof(lastcrimestring), "No records"); }
						else { format(lastcrimestring, sizeof(lastcrimestring), "%s", PlayerData[i][Character_Last_Crime]); }
						
						if(strlen(PlayerData[i][Character_Jail_Reason]) == 0) { format(lastjailedstring, sizeof(lastjailedstring), "No records"); }
						else { format(lastjailedstring, sizeof(lastjailedstring), "%s", PlayerData[i][Character_Jail_Reason]); }
				        
				        if(PlayerData[i][Character_License_Car] == 1) { format(L1, sizeof(L1), "Issued"); }
				        else if(PlayerData[i][Character_License_Car] == 0) { format(L1, sizeof(L1), "Not Obtained"); }
				        
				        if(PlayerData[i][Character_License_Truck] == 1) { format(L2, sizeof(L2), "Issued"); }
				        else if(PlayerData[i][Character_License_Truck] == 0) { format(L2, sizeof(L2), "Not Obtained"); }
				        
				        if(PlayerData[i][Character_License_Motorcycle] == 1) { format(L3, sizeof(L3), "Issued"); }
				        else if(PlayerData[i][Character_License_Motorcycle] == 0) { format(L3, sizeof(L3), "Not Obtained"); }
				        
				        if(PlayerData[i][Character_License_Boat] == 1) { format(L4, sizeof(L4), "Issued"); }
				        else if(PlayerData[i][Character_License_Boat] == 0) { format(L4, sizeof(L4), "Not Obtained"); }
				        
				        if(PlayerData[i][Character_License_Flying] == 1) { format(L5, sizeof(L5), "Issued"); }
				        else if(PlayerData[i][Character_License_Flying] == 0) { format(L5, sizeof(L5), "Not Obtained"); }
				        
				        if(PlayerData[i][Character_License_Firearms] == 1) { format(L6, sizeof(L6), "Issued"); }
				        else if(PlayerData[i][Character_License_Firearms] == 0) { format(L6, sizeof(L6), "Not Obtained"); }
				  
				        new bodytext[2000];
	           			format(bodytext, sizeof(bodytext), "Name:\t%s\nAge:\t%i\nSex:\t%s\n \nOutstanding Tickets:\t$%i\nLastest Crime:\t%s\nLast Jailed Reason:\t%s\n \nMotorcycle License:\t%s\nDrivers License:\t%s\nTruck License:\t%s\nBoat License:\t%s\nFlying License:\t%s\nFirearms License:\t%s", PlayerData[i][Character_Name], PlayerData[i][Character_Age], PlayerData[i][Character_Sex], PlayerData[i][Character_Total_Ticket_Amount], lastcrimestring, lastjailedstring, L1, L2, L3, L4, L5, L6);

						ShowPlayerDialog(playerid, DIALOG_MDC_PLAYER_RESULTS, DIALOG_STYLE_TABLIST, "MDC - Player Results", bodytext, "Go Back", "Close");
						
						foundPlayer = true;
						break;
				    }
				}
				if(!foundPlayer)
    			{
					new bodytext[256];
	           		format(bodytext, sizeof(bodytext), "(ERROR - Invalid Player Name)\n\nPlease enter in the player name that you need to check: (Firstname_Lastname)");

					ShowPlayerDialog(playerid, DIALOG_MDC_PLAYER_SEARCH, DIALOG_STYLE_INPUT, "MDC - Player Search", bodytext, "Search", "Go Back");
			    }
			}
		}
		case DIALOG_MDC_PLAYER_RESULTS:
	    {
	        if(!response) return 1;
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_MDC_MENU, DIALOG_STYLE_LIST, "Los Santos Government - MDC", "Search Player Records\nSearch Vehicle Records", "Select", "Close");
			}
		}
		case DIALOG_MDC_VEHICLE_SEARCH:
	    {
	        if(!response) return ShowPlayerDialog(playerid, DIALOG_MDC_MENU, DIALOG_STYLE_LIST, "Los Santos Government - MDC", "Search Player Records\nSearch Vehicle Records", "Select", "Close");
			else
			{
			    new foundVehicle = false;

			    for(new i = 0; i < MAX_VEHICLES; i++)
				{
				    if(strcmp(inputtext, VehicleData[i][Vehicle_License_Plate]) == 0)
					{
     			        new bodytext[500], modelname[50], ownername[50];
     			        
		                if(VehicleData[i][Vehicle_Faction] == 0)
						{
							format(ownername, sizeof(ownername), "%s", VehicleData[i][Vehicle_Owner]);
						}
						else
						{
							format(ownername, sizeof(ownername), "%s", FactionData[i][Faction_Name]);
						}
						
     			        format(modelname, sizeof(modelname), "%s", GetVehicleModelName(VehicleData[i][Vehicle_Model]));
 						format(bodytext, sizeof(bodytext), "Vehicle Model:\t%s\nVehicle Plate:\t%s\nVehicle Owner:\t%s\n \nRelated Crime:\tNo Records\nImpounded:\tNo Records", modelname, VehicleData[i][Vehicle_License_Plate], ownername);

						ShowPlayerDialog(playerid, DIALOG_MDC_VEHICLE_RESULTS, DIALOG_STYLE_TABLIST, "MDC - Vehicle Results", bodytext, "Go Back", "Close");

						foundVehicle = true;
						break;
				    }
				}
				if(!foundVehicle)
    			{
					new bodytext[256];
	           		format(bodytext, sizeof(bodytext), "(ERROR - Invalid License Plate Number)\n\nPlease enter in the license plate number of the vehicle: (ORP 001)");

					ShowPlayerDialog(playerid, DIALOG_MDC_VEHICLE_SEARCH, DIALOG_STYLE_INPUT, "MDC - Vehicle Search", bodytext, "Search", "Go Back");
			    }
			}
		}
		case DIALOG_MDC_VEHICLE_RESULTS:
	    {
	        if(!response) return 1;
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_MDC_MENU, DIALOG_STYLE_LIST, "Los Santos Government - MDC", "Search Player Records\nSearch Vehicle Records", "Select", "Close");
			}
		}
		case DIALOG_PLAYER_SKINS:
	    {
			if(!response) return 1;
			else
			{
		        switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Skin_1] > 0) return SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
		                else return SendPlayerErrorMessage(playerid, " You do not have an outfit saved in this slot to put any clothes on!");
		            }
		            case 1:
		            {
	                    if(PlayerData[playerid][Character_Skin_2] > 0) return SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_2]);
		                else return SendPlayerErrorMessage(playerid, " You do not have an outfit saved in this slot to put any clothes on!");
		            }
		            case 2:
		            {
	                    if(PlayerData[playerid][Character_Skin_3] > 0) return SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_3]);
		                else return SendPlayerErrorMessage(playerid, " You do not have an outfit saved in this slot to put any clothes on!");
		            }
		        }
			}
	    }
		case DIALOG_PLAYER_SHOP_SKIN:
	    {
			if(!response) return 1;
			else
			{
		        switch(listitem)
		        {
		            case 0:
		            {
		                PlayerData[playerid][Character_Skin_1] =  GetPlayerSkin(playerid);
						Binco_New_Outfit[playerid] = 1;
		            }
		            case 1:
		            {
	                    PlayerData[playerid][Character_Skin_2] =  GetPlayerSkin(playerid);
						Binco_New_Outfit[playerid] = 2;
		            }
		            case 2:
		            {
	                    PlayerData[playerid][Character_Skin_3] =  GetPlayerSkin(playerid);
						Binco_New_Outfit[playerid] = 3;
		            }
		        }
			}
	    }
	    case DIALOG_LSPD_SEARCH:
	    {
	        if(!response) return 1;
	        else
	        {
	            new targetid, string[256];
	            targetid = WhoHasBeenSearched[playerid];
	            
	            switch(listitem)
	            {
	                case 0:
	                {
	                    if(PlayerData[targetid][Character_Has_Rope] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Rope] = 0;
                            
                            format(string, sizeof(string), "> %s has just removed ropes off of %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed ropes from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
	                    
	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any ropes on their person!", "Go Back", "Close");
	                }
	                case 1:
	                {
	                    if(PlayerData[targetid][Character_Has_Fuelcan] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Fuelcan] = 0;

                            format(string, sizeof(string), "> %s has just removed fuelcans from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed fuelcans from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any fuelcans on their person!", "Go Back", "Close");
	                }
	                case 2:
	                {
	                    if(PlayerData[targetid][Character_Has_Lockpick] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Lockpick] = 0;

                            format(string, sizeof(string), "> %s has just removed lockpicks from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed lockpicks from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any lockpicks on their person!", "Go Back", "Close");
	                }
	                case 3:
	                {
	                    if(PlayerData[targetid][Character_Has_Drugs] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Drugs] = 0;

                            format(string, sizeof(string), "> %s has just removed drugs from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed drugs from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any drugs on their person!", "Go Back", "Close");
	                }
	                case 4:
	                {
	                    if(PlayerData[targetid][Character_Has_Food] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Food] = 0;

                            format(string, sizeof(string), "> %s has just removed food from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed food from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any food on their person!", "Go Back", "Close");
	                }
	                case 5:
	                {
	                    if(PlayerData[targetid][Character_Has_Drinks] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Drinks] = 0;

                            format(string, sizeof(string), "> %s has just removed drinks from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed drinks from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any drinks on their person!", "Go Back", "Close");
	                }
	                case 6:
	                {
	                    if(PlayerData[targetid][Character_Has_Alcohol] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Alcohol] = 0;

                            format(string, sizeof(string), "> %s has just removed alcohol from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed alochol from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any alochol on their person!", "Go Back", "Close");
	                }
	                case 7:
	                {
	                    if(PlayerData[targetid][Character_Has_Device] > 0)
	                    {
                            PlayerData[targetid][Character_Has_Device] = 0;

                            format(string, sizeof(string), "> %s has just removed hacking devices from %s", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have just removed hacking devices from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);

	                        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
	                    }
	                    else return ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH_RESULTS, DIALOG_STYLE_MSGBOX, "Searched Inventory.. - [Unsucessful]", "This character does not hold any alochol on their person!", "Go Back", "Close");
	                }
	            }
	        }
	    }
	    case DIALOG_LSPD_SEARCH_RESULTS:
	    {
			if(!response) return 1;
			else
			{
			    new targetid;
	            targetid = WhoHasBeenSearched[playerid];
	            
			    new bodytext[2000];
    			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);
				ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
			}
	    }
	    case DIALOG_SHOP_TYPE_ONE:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        new string[256];
		        
		        switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Money] >= 12)
		                {
			                PlayerData[playerid][Character_Has_Food] += 1;
			                PlayerData[playerid][Character_Money] -= 12;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some food from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                if(PlayerData[playerid][Character_Money] >= 4)
		                {
			                PlayerData[playerid][Character_Has_Drinks] += 1;
			                PlayerData[playerid][Character_Money] -= 4;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_drinks` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Drinks], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some soda from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
                        else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
		            case 2:
		            {
		                if(PlayerData[playerid][Character_Money] >= 30)
		                {
			                PlayerData[playerid][Character_Has_Alcohol] += 1;
			                PlayerData[playerid][Character_Money] -= 30;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_alcohol` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Alcohol], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some alcohol from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
		            case 3:
		            {
		                if(PlayerData[playerid][Character_Money] >= 800)
		                {
			                PlayerData[playerid][Character_Has_Lockpick] += 1;
			                PlayerData[playerid][Character_Money] -= 800;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_lockpick` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Lockpick], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a lockpick from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
		            case 4:
		            {
		                if(PlayerData[playerid][Character_Money] >= 200)
		                {
			                PlayerData[playerid][Character_Has_Rope] += 1;
			                PlayerData[playerid][Character_Money] -= 200;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_rope` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Rope], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some rope from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
					case 5:
		            {
		                if(PlayerData[playerid][Character_Money] >= 2500)
		                {
			                PlayerData[playerid][Character_Has_Mask] += 1;
			                PlayerData[playerid][Character_Money] -= 2500;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_mask` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Mask], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a mask from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_TYPE_TWO:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        new string[256];

		        switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Money] >= 4)
		                {
			                PlayerData[playerid][Character_Has_Food] += 1;
			                PlayerData[playerid][Character_Money] -= 4;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some fruit from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                if(PlayerData[playerid][Character_Money] >= 3)
		                {
			                PlayerData[playerid][Character_Has_Food] += 1;
			                PlayerData[playerid][Character_Money] -= 3;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some vegetables from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
                        else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		            case 2:
		            {
		                if(PlayerData[playerid][Character_Money] >= 50)
		                {
			                PlayerData[playerid][Character_Has_Drinks] += 1;
			                PlayerData[playerid][Character_Money] -= 50;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_drinks` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Drinks], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some drinks from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		            case 3:
		            {
		                if(PlayerData[playerid][Character_Money] >= 5)
		                {
			                PlayerData[playerid][Character_Has_Drinks] += 1;
			                PlayerData[playerid][Character_Money] -= 5;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_drinks` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Drinks], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some milk from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		            case 4:
		            {
		                if(PlayerData[playerid][Character_Money] >= 12)
		                {
			                PlayerData[playerid][Character_Has_Food] += 1;
			                PlayerData[playerid][Character_Money] -= 12;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some cheese from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		            case 5:
		            {
		                SendPlayerErrorMessage(playerid, " This item doesn't exist yet within the server (coming soon)!");
		                ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
		                /*if(PlayerData[playerid][Character_Money] >= 250)
		                {
			                PlayerData[playerid][Character_Has_Rope] += 1;
			                PlayerData[playerid][Character_Money] -= 250;

			                format(string, sizeof(string), "> %s has just purchased some metal fragments from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}*/
		            }
		            case 6:
		            {
		                if(PlayerData[playerid][Character_Money] >= 8)
		                {
			                PlayerData[playerid][Character_Has_Food] += 1;
			                PlayerData[playerid][Character_Money] -= 8;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some meat from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_TYPE_THREE:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, DIALOG_SHOP_3_MOB, DIALOG_STYLE_LIST, "Electronic Store - Mobile Phones", "Nokia ($500)\nSamsung ($2000)\niPhone ($2500)\nHacking Device ($5000)", "Purchase", "Close");
		            }
		            case 1:
		            {
		                ShowPlayerDialog(playerid, DIALOG_SHOP_3_SIM, DIALOG_STYLE_LIST, "Electronic Store - Sim Cards", "Telecom Network ($250)\nValley Network ($450)", "Purchase", "Close");
		            }
					case 2:
		            {
		                ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
		            }
		        }
		    }
		}
		case DIALOG_SHOP_3_MOB:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        new string[256];

		        switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Money] >= 500)
		                {
			                PlayerData[playerid][Character_Has_Phone] = 1;
			                PlayerData[playerid][Character_Money] -= 500;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_phone` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Phone], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Nokia Phone from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_MOB, DIALOG_STYLE_LIST, "Electronic Store - Mobile Phones", "Nokia ($500)\nSamsung ($2000)\niPhone ($2500)\nHacking Device ($5000)", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                if(PlayerData[playerid][Character_Money] >= 2000)
		                {
			                PlayerData[playerid][Character_Has_Phone] = 2;
			                PlayerData[playerid][Character_Money] -= 2000;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_phone` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Phone], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Samsung Phone from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_MOB, DIALOG_STYLE_LIST, "Electronic Store - Mobile Phones", "Nokia ($500)\nSamsung ($2000)\niPhone ($2500)\nHacking Device ($5000)", "Purchase", "Close");
						}
		            }
					case 2:
		            {
		                if(PlayerData[playerid][Character_Money] >= 2500)
		                {
			                PlayerData[playerid][Character_Has_Phone] = 3;
			                PlayerData[playerid][Character_Money] -= 2500;
			                
			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_phone` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Phone], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a iPhone from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_MOB, DIALOG_STYLE_LIST, "Electronic Store - Mobile Phones", "Nokia ($500)\nSamsung ($2000)\niPhone ($2500)\nHacking Device ($5000)", "Purchase", "Close");
						}
		            }
		            case 3:
		            {
		                if(PlayerData[playerid][Character_Money] >= 5000)
		                {
			                PlayerData[playerid][Character_Has_Device] += 1;
			                PlayerData[playerid][Character_Money] -= 5000;

			                new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_device` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Device], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a device from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_MOB, DIALOG_STYLE_LIST, "Electronic Store - Mobile Phones", "Nokia ($500)\nSamsung ($2000)\niPhone ($2500)\nHacking Device ($5000)", "Purchase", "Close");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_3_SIM:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        new string[256];

		        switch(listitem)
		        {
		            case 0:
		            {
		                if(PlayerData[playerid][Character_Money] >= 250)
		                {
			                PlayerData[playerid][Character_Has_SimCard] = 1;
			                PlayerData[playerid][Character_Money] -= 250;
			                
			                SQL_PHONENUMBER_USED = 0;

				            new MAX_ATTEMPTS = 3;
				            for (new i = 0; i < MAX_ATTEMPTS; i++)
				            {
				                if(SQL_PHONENUMBER_USED == 0)
				                {
				                    SQL_PHONENUMBER_GENERATED = 100000 + random(900000);

				                    new query[128];
								    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_phonenumber` = '%i' LIMIT 1", SQL_PHONENUMBER_GENERATED);
									mysql_tquery(connection, query, "GetNextPhoneNumber");
				                }
				                else return 1;
				            }

				            PlayerData[playerid][Character_Phonenumber] = SQL_PHONENUMBER_GENERATED;
				            
				            new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_simcard` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_SimCard], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Telecom Network simcard from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_SIM, DIALOG_STYLE_LIST, "Electronic Store - Sim Cards", "Telecom Network ($250)\nValley Network ($450)", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                if(PlayerData[playerid][Character_Money] >= 450)
		                {
			                PlayerData[playerid][Character_Has_SimCard] = 2;
			                PlayerData[playerid][Character_Money] -= 450;
			                
			                SQL_PHONENUMBER_USED = 0;

				            new MAX_ATTEMPTS = 3;
				            for (new i = 0; i < MAX_ATTEMPTS; i++)
				            {
				                if(SQL_PHONENUMBER_USED == 0)
				                {
				                    SQL_PHONENUMBER_GENERATED = 100000 + random(900000);

				                    new query[128];
								    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_phonenumber` = '%i' LIMIT 1", SQL_PHONENUMBER_GENERATED);
									mysql_tquery(connection, query, "GetNextPhoneNumber");
				                }
				                else return 1;
				            }
				            
				            PlayerData[playerid][Character_Phonenumber] = SQL_PHONENUMBER_GENERATED;
				            
				            new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_simcard` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_SimCard], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Valley Network simcard from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_SIM, DIALOG_STYLE_LIST, "Electronic Store - Sim Cards", "Telecom Network ($250)\nValley Network ($450)", "Purchase", "Close");
						}
					}
		        }
		    }
		}
		case DIALOG_SHOP_3_HOUSE:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {					
		            case 0:
		            {						
		                if(PlayerData[playerid][Character_Money] >= 2500)
		                {
							for(new a = 1; a < MAX_HOUSES; a++)
							{
								if(a != 0 && HouseData[a][House_Owner] == PlayerData[playerid][Character_Name])
								{
								    FoundPlayerHouseID[playerid] = a;
								}
							}
							
							if(FoundPlayerHouseID[playerid] == 0) 
							{
								SendPlayerErrorMessage(playerid, " You do not own a property to buy a lock for!");
								ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
							}
							else
							{
								if(HouseData[FoundPlayerHouseID[playerid]][House_Lock] == 1)
								{
									SendPlayerErrorMessage(playerid, " You already have a lock for your house!");
									ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
								}
								else
								{
									HouseData[FoundPlayerHouseID[playerid]][House_Lock] = 1;
									
									new updatequery[2000];
							        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `house_information` SET `house_lock` = 1 WHERE `house_id` = '%i' LIMIT 1", FoundPlayerHouseID[playerid]);
						    		mysql_tquery(connection, updatequery);
						
									PlayerData[playerid][Character_Money] -= 2500;
						
									FoundPlayerHouseID[playerid] = 0;
									
									new string[256];
									format(string, sizeof(string), "> %s has just purchased a House Lock from the store", GetName(playerid));
									SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
									
									new string1[256];
									format(string1, sizeof(string1), "- You can now lock your house by typing /lock near your front door!");
									SendClientMessage(playerid, COLOR_YELLOW, string1);
								}
							}
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                if(PlayerData[playerid][Character_Money] >= 5500)
		                {
							for(new a = 1; a < MAX_HOUSES; a++)
							{
								if(a != 0 && HouseData[a][House_Owner] == PlayerData[playerid][Character_Name])
								{
								    FoundPlayerHouseID[playerid] = a;
								}
							}
							
							if(FoundPlayerHouseID[playerid] == 0) 
							{
								SendPlayerErrorMessage(playerid, " You do not own a property to buy an alarm for!");
								ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
							}
							else
							{
								if(HouseData[FoundPlayerHouseID[playerid]][House_Alarm] == 1)
								{
									SendPlayerErrorMessage(playerid, " You already have an alarm for your house!");
									ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
								}
								else
								{
									HouseData[FoundPlayerHouseID[playerid]][House_Alarm] = 1;
									
									new updatequery[2000];
							        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `house_information` SET `house_alarm` = 1 WHERE `house_id` = '%i' LIMIT 1", FoundPlayerHouseID[playerid]);
						    		mysql_tquery(connection, updatequery);
						
									PlayerData[playerid][Character_Money] -= 5500;
						
									FoundPlayerHouseID[playerid] = 0;
									
									new string[256];
									format(string, sizeof(string), "> %s has just purchased a House Alarm from the store", GetName(playerid));
									SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
									
									new string1[256];
									format(string1, sizeof(string1), "- You can now alarm your house by typing /alarm near your front door!");
									SendClientMessage(playerid, COLOR_YELLOW, string1);
								}
							}
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_3_HOUSE, DIALOG_STYLE_LIST, "Electronic Store - House Items", "House Lock ($2500)\nHouse Alarm ($5500)", "Purchase", "Close");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_TYPE_FOUR:
		{
			if(!response) return 1;
			
			if(response)
			{
				switch(listitem)
				{					
					case 0:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 10)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 10;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Number 1 from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 1:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 15)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 2;
							PlayerData[playerid][Character_Money] -= 15;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Number 2 from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 2:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 50)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 3;
							PlayerData[playerid][Character_Money] -= 50;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Number 3 from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 3:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 65)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 5;
							PlayerData[playerid][Character_Money] -= 65;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Number 4 from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 4:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 150)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 10;
							PlayerData[playerid][Character_Money] -= 150;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Fat Guy from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
				}
			}
		}
		case DIALOG_SHOP_TYPE_FIVE:
		{
			if(!response) return 1;
			
			if(response)
			{
				switch(listitem)
				{					
					case 0:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 10)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FIVE, DIALOG_STYLE_LIST, "Bar / Resturant", "Vodka ($10)\nRose Bud ($15)\nBeer ($20)\nPeanuts ($4)\nCrisps ($6)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Alcohol] += 1;
							PlayerData[playerid][Character_Money] -= 10;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_alcohol` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Alcohol], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Vodka from the bar", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 1:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 15)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FIVE, DIALOG_STYLE_LIST, "Bar / Resturant", "Vodka ($10)\nRose Bud ($15)\nBeer ($20)\nPeanuts ($4)\nCrisps ($6)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Alcohol] += 1;
							PlayerData[playerid][Character_Money] -= 15;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_alcohol` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Alcohol], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Rose Bud from the bar", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 2:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 20)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FIVE, DIALOG_STYLE_LIST, "Bar / Resturant", "Vodka ($10)\nRose Bud ($15)\nBeer ($20)\nPeanuts ($4)\nCrisps ($6)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Alcohol] += 1;
							PlayerData[playerid][Character_Money] -= 20;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_alcohol` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Alcohol], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Beer from the bar", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 3:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 4)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 4;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased some Peanuts from the bar", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 4:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 6)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Food Store", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 6;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a bag of Crisps from the bar", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
				}
			}
		}
		case DIALOG_SHOP_TYPE_SIX:
		{
		    if(!response) return 1;

		    if(response)
		    {
		    }
		}
		case DIALOG_SHOP_TYPE_SEVEN:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
		            }
		            case 1:
		            {
		                ShowPlayerDialog(playerid, DIALOG_SHOP_7_EXTRAS, DIALOG_STYLE_TABLIST, "Ammunation Store - Extras", "Tear Gas\t$650\nMolotov\t$1500\nBrass Knuckles\t$2500\nArmour\t$3000", "Purchase", "Close");
		            }
		        }
		    }
		}
		case DIALOG_SHOP_7_WEAPONS:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                new string[256];
		                
		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 200)
			                {
								GivePlayerWeapon(playerid, WEAPON_KNIFE, 1);
								
								PlayerData[playerid][Character_Money] -= 200;

				                format(string, sizeof(string), "> %s has just purchased a Knife from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		            case 1:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 1500)
			                {
								GivePlayerWeapon(playerid, WEAPON_COLT45, 50);

								PlayerData[playerid][Character_Money] -= 1500;

				                format(string, sizeof(string), "> %s has just purchased a 9mm Pistol from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		            case 2:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 3500)
			                {
								GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 30);

								PlayerData[playerid][Character_Money] -= 3500;

				                format(string, sizeof(string), "> %s has just purchased a Shotgun from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		            case 3:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 10500)
			                {
								GivePlayerWeapon(playerid, WEAPON_AK47, 80);

								PlayerData[playerid][Character_Money] -= 10500;

				                format(string, sizeof(string), "> %s has just purchased a AK-47 from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		            case 4:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 15000)
			                {
								GivePlayerWeapon(playerid, WEAPON_RIFLE, 30);

								PlayerData[playerid][Character_Money] -= 15000;

				                format(string, sizeof(string), "> %s has just purchased a Rifle from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		            case 5:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_License_Firearms] == 1)
		                {
			                if(PlayerData[playerid][Character_Money] >= 35000)
			                {
								GivePlayerWeapon(playerid, WEAPON_SNIPER, 20);

								PlayerData[playerid][Character_Money] -= 35000;

				                format(string, sizeof(string), "> %s has just purchased a Sniper Rifle from the store", GetName(playerid));
								SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							}
							else
							{
							    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							    ShowPlayerDialog(playerid, DIALOG_SHOP_7_WEAPONS, DIALOG_STYLE_TABLIST, "Ammunation Store - Weapon", "Knife\t$200\n9mm Pistol\t$1500\nShotgun\t$3500\nAK-47\t$10500\nRifle\t$15000\nSniper Rifle\t$35000", "Purchase", "Close");
							}
						}
						else if(PlayerData[playerid][Character_License_Firearms] == 0)
						{
						    ShowPlayerDialog(playerid, DIALOG_SHOP_ROB_SRIFLE, DIALOG_STYLE_MSGBOX, "Ammunation Store - Failure", "You currently do not have a weapon license and are restricted from purchasing certain weapons.\n\nTo obtain your weapon license, you can do so upstairs!", "Close", "");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_7_EXTRAS:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_Money] >= 650)
	                	{
							GivePlayerWeapon(playerid, WEAPON_TEARGAS, 2);

							PlayerData[playerid][Character_Money] -= 650;

			                format(string, sizeof(string), "> %s has just purchased a Tear Gas Bundle from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_7_EXTRAS, DIALOG_STYLE_TABLIST, "Ammunation Store - Extras", "Tear Gas\t$650\nMolotov\t$1500\nBrass Knuckles\t$2500\nArmour\t$3000", "Purchase", "Close");
						}
		            }
		            case 1:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_Money] >= 1500)
	                	{
							GivePlayerWeapon(playerid, WEAPON_MOLTOV, 2);

							PlayerData[playerid][Character_Money] -= 1500;

			                format(string, sizeof(string), "> %s has just purchased a Molotov Bundle from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_7_EXTRAS, DIALOG_STYLE_TABLIST, "Ammunation Store - Extras", "Tear Gas\t$650\nMolotov\t$1500\nBrass Knuckles\t$2500\nArmour\t$3000", "Purchase", "Close");
						}
		            }
		            case 2:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_Money] >= 2500)
	                	{
							GivePlayerWeapon(playerid, WEAPON_BRASSKNUCKLE, 1);

							PlayerData[playerid][Character_Money] -= 2500;

			                format(string, sizeof(string), "> %s has just purchased Brass Knuckles from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_7_EXTRAS, DIALOG_STYLE_TABLIST, "Ammunation Store - Extras", "Tear Gas\t$650\nMolotov\t$1500\nBrass Knuckles\t$2500\nArmour\t$3000", "Purchase", "Close");
						}
		            }
		            case 3:
		            {
		                new string[256];

		                if(PlayerData[playerid][Character_Money] >= 3000)
	                	{
							SetPlayerArmour(playerid, 100.0);

							PlayerData[playerid][Character_Money] -= 3000;

			                format(string, sizeof(string), "> %s has just purchased Armour from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else
						{
						    SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
						    ShowPlayerDialog(playerid, DIALOG_SHOP_7_EXTRAS, DIALOG_STYLE_TABLIST, "Ammunation Store - Extras", "Tear Gas\t$650\nMolotov\t$1500\nBrass Knuckles\t$2500\nArmour\t$3000", "Purchase", "Close");
						}
		            }
		        }
		    }
		}
		case DIALOG_SHOP_TYPE_EIGHT:
		{
			if(!response) return 1;
			
			if(response)
			{
				switch(listitem)
				{					
					case 0:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 10)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_EIGHT, DIALOG_STYLE_LIST, "Donut Shop", "Sprinkles ($10)\nStuffed ($15)\nMystery Filled ($25)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 10;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Sprinkled Donut from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 1:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 15)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_EIGHT, DIALOG_STYLE_LIST, "Donut Shop", "Sprinkles ($10)\nStuffed ($15)\nMystery Filled ($25)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 15;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Stuffed Donut from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
					case 2:
					{
						new string[256];
						
						if(PlayerData[playerid][Character_Money] < 25)
						{
							SendPlayerErrorMessage(playerid, " You do not have enough money to make this purchase!");
							ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_EIGHT, DIALOG_STYLE_LIST, "Donut Shop", "Sprinkles ($10)\nStuffed ($15)\nMystery Filled ($25)", "Purchase", "Close");
						}
						else
						{
							PlayerData[playerid][Character_Has_Food] += 1;
							PlayerData[playerid][Character_Money] -= 25;
							
							new updatequery[2000];
					        mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_food` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Food], GetName(playerid));
				    		mysql_tquery(connection, updatequery);

			                format(string, sizeof(string), "> %s has just purchased a Mystery Filled Donut from the store", GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}						
					}
				}
			}
		}
		case DIALOG_GPS_MAIN:
		{
		    if(!response) return 1;

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: return ShowPlayerDialog(playerid, DIALOG_GPS_TOP, DIALOG_STYLE_LIST, "Mobile GPS Application - Top Locations", "Bank\nPolice Department\nFire Department\nHospital\nImpound\nGas Station\nElectronic Store", "Select", "Back");
		            case 1: return ShowPlayerDialog(playerid, DIALOG_GPS_FACTIONS, DIALOG_STYLE_LIST, "Mobile GPS Application - Faction Locations", "LSPD\nLSFD\nLSMC\nLS Bank\nTow Co\nTaxi Co\nTruck Co\nDudefix\nGrove Street Gang\nLa Familia Gang\nHell Angels", "Select", "Back");
		            case 2: return ShowPlayerDialog(playerid, DIALOG_GPS_JOBS, DIALOG_STYLE_LIST, "Mobile GPS Application - Job Locations", "Pizza Delivery\nRubbish Driver\nDetective\nFarmer\nParking Warden", "Select", "Back");
				}
		    }
		}
		case DIALOG_GPS_TOP:
		{
		    if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST, "Mobile GPS Application", "Top Locations\nFaction Locations\nJob Locations", "Next", "Close");
		    
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 981.7438, -1161.8739, 25.0859, 3.0);
					}
		            case 1:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1554.3239, -1675.5814, 16.1953, 3.0);
					}
		            case 2: 
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1781.3237, -1716.6764, 13.9422, 3.0);
					}
		            case 3: 
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1172.6438, -1323.1779, 15.4026, 3.0);
					}
		            case 4: 
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1520.2769, -1452.6620, 14.2053, 3.0);
					}
		            case 5: 
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1938.3093, -1777.7871, 13.4416, 3.0);
					}
		            case 6: 
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1103.2216, -1439.9008, 15.7969, 3.0);
					}
		        }
		    }
		}
		case DIALOG_GPS_FACTIONS:
		{
		    if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST, "Mobile GPS Application", "Top Locations\nFaction Locations\nJob Locations", "Next", "Close");

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1554.0565, -1675.5317, 16.1953, 3.0);
					}
		            case 1:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1781.3510, -1717.3450, 13.7177, 3.0);
					}
		            case 2:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2033.3623, -1402.9315, 17.2871, 3.0);
					}
		            case 3:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 981.8309, -1162.0126, 25.0859, 3.0);
					}
		            case 4:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1521.0380, -1452.7711, 14.2062, 3.0);
					}
		            case 5:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2046.4102, -1908.6200, 13.5469, 3.0);
					}
		            case 6:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2190.8887, -2253.3914, 13.5098, 3.0);
					}
					case 7:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2526.6453, -2134.5295, 13.5469, 3.0);
					}
		            case 8:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2462.1221, -1666.1908, 13.4745, 3.0);
					}
		            case 9:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2634.6858, -1055.3274, 69.6235, 3.0);
					}
		            case 10:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1115.6753, -962.1698, 42.7583, 3.0);
					}
		        }
		    }
		}
		case DIALOG_GPS_JOBS:
		{
		    if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST, "Mobile GPS Application", "Top Locations\nFaction Locations\nJob Locations", "Next", "Close");

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2102.2109, -1789.1084, 13.5547, 3.0);
					}
		            case 1:
					{
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 2201.1582, -1974.1382, 13.5576, 3.0);
					}
		            case 2:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1553.8646, -1675.6178, 16.1953, 3.0);
					}
		            case 3:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1073.2678, -343.6434, 73.9922, 3.0);
					}
		            case 4:
		            {
					    GPSOn[playerid] = true;
						SetPlayerCheckpoint(playerid, 1554.4752, -1675.6057, 16.1953, 3.0);
					}
		        }
		    }
		}
        case DIALOG_DEALERSHIP_1_MAIN:
		{
		    if(!response)
		    {
                SetCameraBehindPlayer(playerid);
                
                VEHICLEPROCESS = 0;
                HasPlayerConfirmedVehicleID[playerid] = 0;
		    }

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    VehicleModelPurchasing[playerid] = 474;
					    
					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tHermes\nVehicle Price:\t$25,000", "Confirm", "Go Back");
					}
					case 1:
					{
					    VehicleModelPurchasing[playerid] = 526;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tFortune\nVehicle Price:\t$35,000", "Confirm", "Go Back");
					}
					case 2:
					{
					    VehicleModelPurchasing[playerid] = 587;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tEuros\nVehicle Price:\t$45,000", "Confirm", "Go Back");
					}
					case 3:
					{
					    VehicleModelPurchasing[playerid] = 589;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tClub\nVehicle Price:\t$45,000", "Confirm", "Go Back");
					}
					case 4:
					{
					    VehicleModelPurchasing[playerid] = 545;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tHustler\nVehicle Price:\t$65,000", "Confirm", "Go Back");
					}
					case 5:
					{
					    VehicleModelPurchasing[playerid] = 421;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tWashington\nVehicle Price:\t$80,000", "Confirm", "Go Back");
					}
					case 6:
					{
					    VehicleModelPurchasing[playerid] = 579;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tHuntley\nVehicle Price:\t$90,000", "Confirm", "Go Back");
					}
		        }
		    }
		}
		case DIALOG_DEALERSHIP_1_SELECT:
		{
		    if(!response)
			{
			    VehicleModelPurchasing[playerid] = 0;
			    
				new title[256];
    			format(title, sizeof(title), "Vehicle Options");
		    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
			}
		    if(response)
		    {
		        if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;

                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
		        else
		        {
			        if(VehicleModelPurchasing[playerid] == 474)
			        {
			            if(PlayerData[playerid][Character_Money] >= 25000)
			            {
							if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 526)
			        {
			            if(PlayerData[playerid][Character_Money] >= 35000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 587)
			        {
			            if(PlayerData[playerid][Character_Money] >= 45000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 589)
			        {
			            if(PlayerData[playerid][Character_Money] >= 45000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 545)
			        {
			            if(PlayerData[playerid][Character_Money] >= 65000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 421)
			        {
			            if(PlayerData[playerid][Character_Money] >= 80000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 579)
			        {
			            if(PlayerData[playerid][Character_Money] >= 90000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
						}
			        }
				}
		    }
		}
		case DIALOG_DEALERSHIP_2_MAIN:
		{
		    if(!response)
		    {
                SetCameraBehindPlayer(playerid);

                HasPlayerConfirmedVehicleID[playerid] = 0;
                VEHICLEPROCESS = 0;
		    }

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    VehicleModelPurchasing[playerid] = 429;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tBanshee\nVehicle Price:\t$50,000", "Confirm", "Go Back");
					}
					case 1:
					{
					    VehicleModelPurchasing[playerid] = 480;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tComet\nVehicle Price:\t$52,000", "Confirm", "Go Back");
					}
					case 2:
					{
					    VehicleModelPurchasing[playerid] = 565;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tFlash\nVehicle Price:\t$52,000", "Confirm", "Go Back");
					}
					case 3:
					{
					    VehicleModelPurchasing[playerid] = 559;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tJester\nVehicle Price:\t$55,000", "Confirm", "Go Back");
					}
					case 4:
					{
					    VehicleModelPurchasing[playerid] = 506;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tSuper GT\nVehicle Price:\t$70,000", "Confirm", "Go Back");
					}
					case 5:
					{
					    VehicleModelPurchasing[playerid] = 451;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tTurismo\nVehicle Price:\t$80,000", "Confirm", "Go Back");
					}
					case 6:
					{
					    VehicleModelPurchasing[playerid] = 411;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tInfernus\nVehicle Price:\t$100,000", "Confirm", "Go Back");
					}
		        }
		    }
		}
		case DIALOG_DEALERSHIP_2_SELECT:
		{
		    if(!response)
			{
			    VehicleModelPurchasing[playerid] = 0;

				new title[256];
    			format(title, sizeof(title), "Vehicle Options");
		    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
			}
		    if(response)
		    {
		        if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;

                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
		        else
		        {
			        if(VehicleModelPurchasing[playerid] == 429)
			        {
			            if(PlayerData[playerid][Character_Money] >= 50000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 480)
			        {
			            if(PlayerData[playerid][Character_Money] >= 52000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 565)
			        {
			            if(PlayerData[playerid][Character_Money] >= 52000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 559)
			        {
			            if(PlayerData[playerid][Character_Money] >= 55000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 506)
			        {
			            if(PlayerData[playerid][Character_Money] >= 70000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 451)
			        {
			            if(PlayerData[playerid][Character_Money] >= 80000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 411)
			        {
			            if(PlayerData[playerid][Character_Money] >= 100000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Vehicle Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
						}
			        }
				}
		    }
		}
		case DIALOG_DEALERSHIP_3_MAIN:
		{
		    if(!response)
		    {
                SetCameraBehindPlayer(playerid);

                VEHICLEPROCESS = 0;
                HasPlayerConfirmedVehicleID[playerid] = 0;
		    }

		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0:
					{
					    VehicleModelPurchasing[playerid] = 462;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tFaggio\nVehicle Price:\t$5,000", "Confirm", "Go Back");
					}
					case 1:
					{
					    VehicleModelPurchasing[playerid] = 468;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tSanchez\nVehicle Price:\t$7,000", "Confirm", "Go Back");
					}
					case 2:
					{
					    VehicleModelPurchasing[playerid] = 581;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tBF-400\nVehicle Price:\t$12,000", "Confirm", "Go Back");
					}
					case 3:
					{
					    VehicleModelPurchasing[playerid] = 461;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tPCJ-600\nVehicle Price:\t$15,000", "Confirm", "Go Back");
					}
					case 4:
					{
					    VehicleModelPurchasing[playerid] = 522;

					    new title[256];
			    	    format(title, sizeof(title), "Order Confirmation");
					    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_SELECT, DIALOG_STYLE_MSGBOX, title, "You are about to purchase the following vehicle, please confirm you are happy with it:\n\nVehicle Name:\tNRG-500\nVehicle Price:\t$50,000", "Confirm", "Go Back");
					}
		        }
		    }
		}
		case DIALOG_DEALERSHIP_3_SELECT:
		{
		    if(!response)
			{
       			VehicleModelPurchasing[playerid] = 0;

				new title[256];
    			format(title, sizeof(title), "Bike Options");
		    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
			}
		    if(response)
		    {
		        if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;
                	
                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
		        else
		        {
			        if(VehicleModelPurchasing[playerid] == 462)
			        {
			            if(PlayerData[playerid][Character_Money] >= 5000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Bike Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 468)
			        {
			            if(PlayerData[playerid][Character_Money] >= 7000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Bike Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 581)
			        {
			            if(PlayerData[playerid][Character_Money] >= 12000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Bike Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 461)
			        {
			            if(PlayerData[playerid][Character_Money] >= 15000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Bike Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
						}
			        }
			        else if(VehicleModelPurchasing[playerid] == 522)
			        {
			            if(PlayerData[playerid][Character_Money] >= 50000)
			            {
			                if(HasPlayerConfirmedVehicleID[playerid] == 0)
			    			{
								new query[128];
							    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
							    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
							}
						}
						else
						{
						    VehicleModelPurchasing[playerid] = 0;

						    new title[256];
			    			format(title, sizeof(title), "Bike Options - ~r~(Not Enough Money)");
					    	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
						}
			        }
				}
		    }
		}
		case DIALOG_PIZZA_END:
		{
			if(!response)
			{
				PizzaJobDeliveryPlayer[playerid] = 0;
				PizzaJobDeliveryCount[playerid] = 0;
					
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just ended your pizza delivery run!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);		
				
				DisablePlayerCheckpoint(playerid);
			}
			else
	        {
				PizzaJobDeliveryPlayer[playerid] = 1;
				PizzaJobDeliveryCount[playerid] = 1;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just started the pizza delivery process. Go inside the store and make a pizza");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				SetPlayerCheckpoint(playerid, 374.7064, -117.2319, 1001.4922, 0.5);
			}
		}
		case DIALOG_JOB_VIEW:
		{
		    if(!response) return 1;
			else
	        {
                switch(listitem)
			    {
			        case 0:
					{
						if(TruckJobMoneyStarted == 1)
						{
                            SendPlayerErrorMessage(playerid, " A player has already started this job, please try another one!");
						
						    ShowPlayerDialog(playerid, DIALOG_JOB_VIEW, DIALOG_STYLE_LIST, "Trucking Company - Jobs", "1. Money Transport\n2. Parcel Transport", "Next", "Close");
						}
						else
						{
						    if(TruckJobMoneyStarted == 0 && FactionData[4][Faction_Money] > 100000)
						    {
						        SendPlayerErrorMessage(playerid, " The bank has enough money already, please try another job!");
						        
						        ShowPlayerDialog(playerid, DIALOG_JOB_VIEW, DIALOG_STYLE_LIST, "Trucking Company - Jobs", "1. Money Transport\n2. Gas Transport\n3. Food Transport", "Next", "Close");
						    }
						    else if(TruckJobMoneyStarted == 0 && FactionData[4][Faction_Money] <= 100000)
						    {
						        TruckJobMoneyStarted = 1;
						        TruckJobMoneyPlayer[playerid] = 1;
						        
						        new dstring[256];
								format(dstring, sizeof(dstring), "- You have just started the money job, LSPD has been advised. Grab a vehicle and head to the docks!");
								SendClientMessage(playerid, COLOR_YELLOW, dstring);
						        
						        SetPlayerCheckpoint(playerid, 2788.4670,-2494.4106,13.4753, 20.0);

								format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: All Units, Trucking Company has just started a money drop job)", GetName(playerid));
								SendFactionRadioMessage(1, COLOR_WHITE, dstring);

								print("Truck Money Job Accepted");
						    }
						}
					}
			        case 1:
					{
                        TruckJobParcelPlayer[playerid] = 1;
                        TruckJobParcelCount[playerid] = 0;
                        
                        new dstring[256];
						format(dstring, sizeof(dstring), "- You have just started the parcel delivery job. Grab a van and head to the locations!");
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
						
						new randomNumber = GetValidHouseJobNumber();
						SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 5.0);
					}
			    }
	        }
		}
		case DIALOG_LICENSE_VIEW:
		{
		    if(!response) return 1;
			else
	        {
                switch(listitem)
			    {
			        case 0:
					{
					    if(PlayerData[playerid][Character_Money] < 240) return SendPlayerErrorMessage(playerid, " You do not have enough money to completed this course!");
						else
						{
						    PlayerData[playerid][Character_Money] -= 240;
						    
							DrivingBikePlayer[playerid] = 1;
	                        DrivingBikeCount[playerid] = 1;
						
							HasGPSBeenDisabled[playerid] = 1;

	                        new dstring[256];
							format(dstring, sizeof(dstring), "- You have just started to obtain your motorcycle license, make your way outside and grab a bike!");
							SendClientMessage(playerid, COLOR_YELLOW, dstring);

							SetPlayerCheckpoint(playerid, 1367.2766,-1439.1588,13.1764, 5.0);
						}
					}
					case 1:
					{
						if(PlayerData[playerid][Character_Money] < 500) return SendPlayerErrorMessage(playerid, " You do not have enough money to complete this course!");
						else
						{
						    PlayerData[playerid][Character_Money] -= 500;
						    
							DrivingCarPlayer[playerid] = 1;
	                        DrivingCarCount[playerid] = 1;
	
							HasGPSBeenDisabled[playerid] = 1;

	                        new dstring[256];
							format(dstring, sizeof(dstring), "- You have just started to obtain your car license, make your way outside and grab a car!");
							SendClientMessage(playerid, COLOR_YELLOW, dstring);

							SetPlayerCheckpoint(playerid, 1367.2766,-1439.1588,13.1764, 5.0);
						}
					}
					case 2:
					{
						if(PlayerData[playerid][Character_Money] < 1000) return SendPlayerErrorMessage(playerid, " You do not have enough money to complete this course!");
						else
						{
						    PlayerData[playerid][Character_Money] -= 1000;
						    
							DrivingTruckPlayer[playerid] = 1;
	                        DrivingTruckCount[playerid] = 1;
	
							HasGPSBeenDisabled[playerid] = 1;

	                        new dstring[256];
							format(dstring, sizeof(dstring), "- You have just started to obtain your truck license, make your way outside and grab a truck!");
							SendClientMessage(playerid, COLOR_YELLOW, dstring);

							SetPlayerCheckpoint(playerid, 1367.2766,-1439.1588,13.1764, 5.0);
						}
					}
			    }
	        }
		}
		case DIALOG_DRUG_SELECTION:
		{
		    if(!response) return 1;
			else
	        {
                switch(listitem)
			    {
			        case 0:
					{
					    if(PlayerData[playerid][Character_Has_Drugs] == 0) return SendPlayerErrorMessage(playerid, " You do not have enough drugs to complete this baking!");
						else
						{
							TogglePlayerControllable(playerid, false);
							
							GameTextForPlayer(playerid, "BAKING COCAINE...", 10000, 3);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, false, false, false, false, 0, SYNC_ALL);
							
							HasPlayerBakedDrugs[playerid] = 1;
							
							DrugBaking_Timer[playerid] = SetTimerEx("DrugBakingCocaine", 10000, false, "i", playerid);
						}
					}
					case 1:
					{
						if(PlayerData[playerid][Character_Has_Drugs] < 2) return SendPlayerErrorMessage(playerid, " You do not have enough drugs to complete this baking!");
						else
						{
							TogglePlayerControllable(playerid, false);
							
							GameTextForPlayer(playerid, "BAKING COCAINE...", 15000, 3);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, false, false, false, false, 0, SYNC_ALL);
							
							HasPlayerBakedDrugs[playerid] = 1;
							
							DrugBaking_Timer[playerid] = SetTimerEx("DrugBakingHeroin", 15000, false, "i", playerid);
						}
					}
			    }
	        }
		}
		case DIALOG_SPRAY_PAINT:
		{
			if(!response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				
				MoveDynamicObject(PaintSprayDoor, 1951.66956, -1984.35400, 10.12055, 2, 0.00000, 0.00000, 0);
				
				HasPlayerEnteredSprayUnit[playerid] = 0;
				
				SetCameraBehindPlayer(playerid);
				
				ChangeVehicleColours(vehicleid, VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2]);
				
				//PlayerPlaySound(playerid, 1035, 0.0, 0.0, 0.0);
				
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(vehicleid, true, lights, alarm, doors, bonnet, boot, objective);
			}
			else
	        {
				new vehicleid = GetPlayerVehicleID(playerid);
				
				switch(listitem)
			    {
			        case 0:
					{
					    ChangeVehicleColours(vehicleid, 0, 0);
						HasPlayerChangedVehicleColour[playerid] = 0;						
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 1:
					{
						ChangeVehicleColours(vehicleid, 1, 1);
						HasPlayerChangedVehicleColour[playerid] = 1;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 2:
					{
						ChangeVehicleColours(vehicleid, 2, 2);
						HasPlayerChangedVehicleColour[playerid] = 2;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 3:
					{
						ChangeVehicleColours(vehicleid, 53, 53);
						HasPlayerChangedVehicleColour[playerid] = 53;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");					
					}
					case 4:
					{
						ChangeVehicleColours(vehicleid, 3, 3);
						HasPlayerChangedVehicleColour[playerid] = 3;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 5:
					{
						ChangeVehicleColours(vehicleid, 158, 158);
						HasPlayerChangedVehicleColour[playerid] = 158;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 6:
					{
						ChangeVehicleColours(vehicleid, 128, 128);
						HasPlayerChangedVehicleColour[playerid] = 128;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 7:
					{
						ChangeVehicleColours(vehicleid, 194, 194);
						HasPlayerChangedVehicleColour[playerid] = 194;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 8:
					{
						ChangeVehicleColours(vehicleid, 6, 6);
						HasPlayerChangedVehicleColour[playerid] = 6;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 9:
					{
						ChangeVehicleColours(vehicleid, 146, 146);
						HasPlayerChangedVehicleColour[playerid] = 146;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 10:
					{
						ChangeVehicleColours(vehicleid, 211, 211);
						HasPlayerChangedVehicleColour[playerid] = 165;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
					case 11:
					{
						ChangeVehicleColours(vehicleid, 145, 145);
						HasPlayerChangedVehicleColour[playerid] = 145;
						
						ShowPlayerDialog(playerid, DIALOG_SPRAY_CONFIRM, DIALOG_STYLE_MSGBOX, "Vehicle Colour Confirmation", "You are about to adjust the vehicle colour, are you sure you want to change?", "Confirm", "Go Back");
					}
			    }
			}
		}
		case DIALOG_SPRAY_CONFIRM:
		{
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_SPRAY_PAINT, DIALOG_STYLE_LIST, "Cheapo Spray Paints - Select your new vehilce colour", "Black\nWhite\nLight Blue\nDark Blue\nRed\nOrange\nGreen\nGold\nYellow\nNeon Pink\nNeon Purple\nNeon Green", "Preview", "Close");
			}
			else
	        {
				new vehicleid = GetPlayerVehicleID(playerid);
				
				VehicleData[vehicleid][Vehicle_Color_1] = HasPlayerChangedVehicleColour[playerid];
				VehicleData[vehicleid][Vehicle_Color_2] = HasPlayerChangedVehicleColour[playerid];
				
				new fquery[2000];
				mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_color_1` = '%i', `vehicle_color_2` = '%i' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2], VehicleData[vehicleid][Vehicle_ID]);
				mysql_tquery(connection, fquery);
				
				PlayerData[playerid][Character_Money] -= 500;
				
				HasPlayerChangedVehicleColour[playerid] = 0;
				HasPlayerEnteredSprayUnit[playerid] = 0;
				
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid,true);
				
				MoveDynamicObject(PaintSprayDoor, 1951.66956, -1984.35400, 10.12055, 2, 0.00000, 0.00000, 0);
				//PlayerPlaySound(playerid, 1035, 0.0, 0.0, 0.0);
				
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(vehicleid, true, lights, alarm, doors, bonnet, boot, objective);
			}
		}
	}
    return 1;
}
 
public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source)
{
    return 1;
}

/* -------------- START OF CUSTOM PUBLICS / FORWARDS ---------------------- */

forward OnAccountCreation(playerid);
public OnAccountCreation(playerid)
{
    PlayerData[playerid][Account_ID] = cache_insert_id();
    IsPlayerLogged[playerid] = 1;
    return 1;
}

forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
    if(cache_num_rows() > 0)
    {
        // ----- Account Stats ------ //
		cache_get_value_name_int(0, "account_id", PlayerData[playerid][Account_ID]);
		cache_get_value_name_int(0, "account_ip", PlayerData[playerid][Account_IP]);
		
		cache_get_value_name(0, "account_email", PlayerData[playerid][Account_Email], 129);
		cache_get_value_name(0, "character_password", PlayerData[playerid][Character_Password], 129);

		// ----- Character Stats ------ //
		cache_get_value_name_float(0, "character_pos_x", PlayerData[playerid][Character_Pos_X]);
		cache_get_value_name_float(0, "character_pos_y", PlayerData[playerid][Character_Pos_Y]);
		cache_get_value_name_float(0, "character_pos_z", PlayerData[playerid][Character_Pos_Z]);
		cache_get_value_name_float(0, "character_pos_angle", PlayerData[playerid][Character_Pos_Angle]);
               
        if(PlayerData[playerid][Character_Pos_X] == 0 || PlayerData[playerid][Character_Pos_Y] == 0 || PlayerData[playerid][Character_Pos_Z] == 0)
        {
			PlayerData[playerid][Character_Pos_X] = 1529.6;
			PlayerData[playerid][Character_Pos_Y] = -1691.2;
			PlayerData[playerid][Character_Pos_Z] = 13.3;
        }

		cache_get_value_name_float(0, "character_health", PlayerData[playerid][Character_Health]);
		cache_get_value_name_float(0, "character_armor", PlayerData[playerid][Character_Armor]);
        cache_get_value_name_int(0, "character_registered", PlayerData[playerid][Character_Registered]);
		cache_get_value_name_int(0, "character_age", PlayerData[playerid][Character_Age]);
	    cache_get_value_name(0, "character_sex", PlayerData[playerid][Character_Sex], 129);
		cache_get_value_name(0, "character_birthplace", PlayerData[playerid][Character_Birthplace], 129);
	
	    cache_get_value_name_int(0, "character_skin_1", PlayerData[playerid][Character_Skin_1]);
		cache_get_value_name_int(0, "character_skin_2", PlayerData[playerid][Character_Skin_2]);
		cache_get_value_name_int(0, "character_skin_3", PlayerData[playerid][Character_Skin_3]);
		cache_get_value_name_int(0, "character_skin_logout", PlayerData[playerid][Character_Skin_Logout]);
		cache_get_value_name_int(0, "character_last_login", PlayerData[playerid][Character_Last_Login]);
		cache_get_value_name_int(0, "character_minutes", PlayerData[playerid][Character_Minutes]);
		cache_get_value_name_int(0, "character_ban", PlayerData[playerid][Character_Ban]);
	    
		cache_get_value_name_int(0, "character_job", PlayerData[playerid][Character_Job]);
	    cache_get_value_name_int(0, "character_faction", PlayerData[playerid][Character_Faction]);
		cache_get_value_name_int(0, "character_faction_rank", PlayerData[playerid][Character_Faction_Rank]);
		cache_get_value_name_int(0, "character_faction_join_request", PlayerData[playerid][Character_Faction_Join_Request]);
		cache_get_value_name_int(0, "character_faction_ban", PlayerData[playerid][Character_Faction_Ban]);
		
		cache_get_value_name_int(0, "character_money", PlayerData[playerid][Character_Money]);
		cache_get_value_name_int(0, "character_coins", PlayerData[playerid][Character_Coins]);
		cache_get_value_name_int(0, "character_bank_account", PlayerData[playerid][Character_Bank_Account]);
		cache_get_value_name_int(0, "character_bank_money", PlayerData[playerid][Character_Bank_Money]);
		cache_get_value_name_int(0, "character_bank_loan", PlayerData[playerid][Character_Bank_Loan]);
       	cache_get_value_name(0, "character_bank_pin", PlayerData[playerid][Character_Bank_Pin], 129);
       	cache_get_value_name_int(0, "character_vip", PlayerData[playerid][Character_VIP]);

		cache_get_value_name_int(0, "character_interior_id", PlayerData[playerid][Character_Interior_ID]);
		cache_get_value_name_int(0, "character_virtual_world", PlayerData[playerid][Character_Virtual_World]);
		cache_get_value_name_int(0, "character_house_id", PlayerData[playerid][Character_House_ID]);
		cache_get_value_name_int(0, "character_total_houses", PlayerData[playerid][Character_Total_Houses]);
		cache_get_value_name_int(0, "character_owns_faction", PlayerData[playerid][Character_Owns_Faction]);
		cache_get_value_name_int(0, "character_business_id", PlayerData[playerid][Character_Business_ID]);
		cache_get_value_name_int(0, "character_total_businesses", PlayerData[playerid][Character_Total_Businesses]);
		
		cache_get_value_name_int(0, "character_ticket_amount", PlayerData[playerid][Character_Ticket_Amount]);
		cache_get_value_name_int(0, "character_total_ticket_amount", PlayerData[playerid][Character_Total_Ticket_Amount]);
		cache_get_value_name_int(0, "character_jail", PlayerData[playerid][Character_Jail]);
		cache_get_value_name_int(0, "character_jail_time", PlayerData[playerid][Character_Jail_Time]);
       	cache_get_value_name(0, "character_jail_reason", PlayerData[playerid][Character_Jail_Reason], 50);
		cache_get_value_name(0, "character_last_crime", PlayerData[playerid][Character_Last_Crime], 50);
        
		// ----- Level Stats ------ //
		cache_get_value_name_int(0, "character_level", PlayerData[playerid][Character_Level]);
		cache_get_value_name_int(0, "character_level_exp", PlayerData[playerid][Character_Level_Exp]);
		cache_get_value_name_int(0, "helper_level", PlayerData[playerid][Helper_Level]);
		cache_get_value_name_int(0, "moderator_level", PlayerData[playerid][Moderator_Level]);		
		cache_get_value_name_int(0, "admin_level", PlayerData[playerid][Admin_Level]);
		cache_get_value_name_int(0, "admin_level_exp", PlayerData[playerid][Admin_Level_Exp]);
	    
	    // ----- ADMIN ------ //
	    cache_get_value_name_int(0, "admin_jail", PlayerData[playerid][Admin_Jail]);
		cache_get_value_name_int(0, "admin_jail_time", PlayerData[playerid][Admin_Jail_Time]);
	    cache_get_value_name(0, "admin_jail_reason", PlayerData[playerid][Admin_Jail_Reason], 50);
	    
	    // ----- INVENTORY ------ //
	    cache_get_value_name_int(0, "weapon_slot_1", PlayerData[playerid][Weapon_Slot_1]);
		cache_get_value_name_int(0, "weapon_slot_2", PlayerData[playerid][Weapon_Slot_2]);
		cache_get_value_name_int(0, "weapon_slot_3", PlayerData[playerid][Weapon_Slot_3]);
		cache_get_value_name_int(0, "weapon_slot_4", PlayerData[playerid][Weapon_Slot_4]);
		cache_get_value_name_int(0, "weapon_slot_5", PlayerData[playerid][Weapon_Slot_5]);
		cache_get_value_name_int(0, "weapon_slot_6", PlayerData[playerid][Weapon_Slot_6]);
		
		cache_get_value_name_int(0, "ammo_slot_1", PlayerData[playerid][Ammo_Slot_1]);
		cache_get_value_name_int(0, "ammo_slot_2", PlayerData[playerid][Ammo_Slot_2]);
		cache_get_value_name_int(0, "ammo_slot_3", PlayerData[playerid][Ammo_Slot_3]);
		cache_get_value_name_int(0, "ammo_slot_4", PlayerData[playerid][Ammo_Slot_4]);
		cache_get_value_name_int(0, "ammo_slot_5", PlayerData[playerid][Ammo_Slot_5]);
		cache_get_value_name_int(0, "ammo_slot_6", PlayerData[playerid][Ammo_Slot_6]);
		
		cache_get_value_name_int(0, "character_radio", PlayerData[playerid][Character_Radio]);
		cache_get_value_name_int(0, "character_license_car", PlayerData[playerid][Character_License_Car]);
		cache_get_value_name_int(0, "character_license_truck", PlayerData[playerid][Character_License_Truck]);
		cache_get_value_name_int(0, "character_license_motorcycle", PlayerData[playerid][Character_License_Motorcycle]);
		cache_get_value_name_int(0, "character_license_boat", PlayerData[playerid][Character_License_Boat]);
		cache_get_value_name_int(0, "character_license_firearms", PlayerData[playerid][Character_License_Firearms]);
		cache_get_value_name_int(0, "character_license_flying", PlayerData[playerid][Character_License_Flying]);
		
		cache_get_value_name_int(0, "character_drug_cocaine", PlayerData[playerid][Character_Drug_Cocaine]);
		cache_get_value_name_int(0, "character_drug_heroin", PlayerData[playerid][Character_Drug_Heroin]);		
		
		cache_get_value_name_int(0, "character_has_rope", PlayerData[playerid][Character_Has_Rope]);
		cache_get_value_name_int(0, "character_has_fuelcan", PlayerData[playerid][Character_Has_Fuelcan]);
		cache_get_value_name_int(0, "character_has_lockpick", PlayerData[playerid][Character_Has_Lockpick]);
		cache_get_value_name_int(0, "character_has_device", PlayerData[playerid][Character_Has_Device]);
		cache_get_value_name_int(0, "character_has_drugs", PlayerData[playerid][Character_Has_Drugs]);
		cache_get_value_name_int(0, "character_has_food", PlayerData[playerid][Character_Has_Food]);
		cache_get_value_name_int(0, "character_has_mask", PlayerData[playerid][Character_Has_Mask]);
		cache_get_value_name_int(0, "character_has_drinks", PlayerData[playerid][Character_Has_Drinks]);
		cache_get_value_name_int(0, "character_has_alcohol", PlayerData[playerid][Character_Has_Alcohol]);
		cache_get_value_name_int(0, "character_has_phone", PlayerData[playerid][Character_Has_Phone]);
		cache_get_value_name_int(0, "character_phonenumber", PlayerData[playerid][Character_Phonenumber]);
		cache_get_value_name_int(0, "character_has_simcard", PlayerData[playerid][Character_Has_SimCard]);
		
		cache_get_value_name_int(0, "character_hotel_id", PlayerData[playerid][Character_Hotel_ID]);

	    cache_get_value_name_float(0, "hotel_character_pos_x", PlayerData[playerid][Hotel_Character_Pos_X]);
		cache_get_value_name_float(0, "hotel_character_pos_y", PlayerData[playerid][Hotel_Character_Pos_Y]);
		cache_get_value_name_float(0, "hotel_character_pos_z", PlayerData[playerid][Hotel_Character_Pos_Z]);
		cache_get_value_name_float(0, "hotel_character_pos_angle", PlayerData[playerid][Hotel_Character_Pos_Angle]);
        cache_get_value_name_int(0, "hotel_character_interior_id", PlayerData[playerid][Hotel_Character_Interior_ID]);
		cache_get_value_name_int(0, "hotel_character_virtual_world", PlayerData[playerid][Hotel_Character_Virtual_World]);
		
		cache_get_value_name_int(0, "character_total_vehicles", PlayerData[playerid][Character_Total_Vehicles]);

        if(PlayerData[playerid][Character_Ban] == 1)
		{
			ShowPlayerDialog(playerid, DIALOG_BAN_MSG, DIALOG_STYLE_MSGBOX, "Open Roleplay - Ban Notice", "You have been recently banned from the server for commiting an offense.\n\nPlease reach out on our discord to have your ban revoked or send a help request through now!", "Unban", "Quit");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Open Roleplay - Login", "Welcome back, %s!\n\nThis account has been registered before.\n\nPlease enter in the accounts password below:", "Login", "Quit", GetName(playerid));
		}
    }
    else
    {
         ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Open Roleplay - Registration", "This account has not been registered before on this server.\n\nPlease enter in a password that you will remember.", "Register", "Quit");
    }
    return 1;
}

forward Save_Character_Info_Query_1(playerid);
public Save_Character_Info_Query_1(playerid)
{
	new Float:a, Float:h, playerquery[2000], skinid;

    GetPlayerPos(playerid, PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]);
	GetPlayerFacingAngle(playerid, PlayerData[playerid][Character_Pos_Angle]);
	PlayerData[playerid][Character_Interior_ID] = GetPlayerInterior(playerid);
	PlayerData[playerid][Character_Virtual_World] = GetPlayerVirtualWorld(playerid);
	
	skinid = GetPlayerSkin(playerid);
 	PlayerData[playerid][Character_Skin_Logout] = skinid;

 	GetPlayerHealth(playerid, h);
	GetPlayerArmour(playerid, a);
	PlayerData[playerid][Character_Health] = h;
	PlayerData[playerid][Character_Armor] = a;
	
    mysql_format(connection, playerquery, sizeof(playerquery), "UPDATE `user_accounts` SET \
																`character_age` = '%i', \
																`character_sex` = '%s', \
																`character_birthplace` = '%s', \
																`character_registered` = '%i', \
																`character_skin_1` = '%i', \
																`character_skin_2` = '%i', \
																`character_skin_3` = '%i', \
																`character_skin_logout` = '%i', \
																`character_last_login` = '%i', \
																`character_minutes` = '%i', \
																`character_ban` = '%i', \
																`character_health` = '%f', \
																`character_armor` = '%f', \
																`character_faction` = '%i', \
																`character_faction_rank` = '%i', \
																`character_faction_join_request` = '%i', \
																`character_faction_ban` = '%i', \
																`character_money` = '%i', \
																`character_coins` = '%i', \
																`character_bank_account` = '%i', \
																`character_bank_money` = '%i', \
																`character_bank_pin` = '%s', \
																`character_bank_loan` = '%i', \
																`character_vip` = '%i', \
																`character_pos_x` = '%f', `character_pos_y` = '%f', `character_pos_z` = '%f', `character_pos_angle` = '%f', `character_interior_id` = '%i', `character_virtual_world` = '%i', \
																`character_house_id` = '%i', `character_total_houses` = '%i', `character_total_businesses` = '%i', `character_business_id` = '%i', \
																`character_level` = '%i', `character_level_exp` = '%i' WHERE `character_name` = '%e' "
	
					, PlayerData[playerid][Character_Age] , PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Skin_1]
				    , PlayerData[playerid][Character_Skin_2], PlayerData[playerid][Character_Skin_3], PlayerData[playerid][Character_Skin_Logout], PlayerData[playerid][Character_Last_Login], PlayerData[playerid][Character_Minutes], PlayerData[playerid][Character_Ban]
				    , PlayerData[playerid][Character_Health], PlayerData[playerid][Character_Armor], PlayerData[playerid][Character_Faction], PlayerData[playerid][Character_Faction_Rank], PlayerData[playerid][Character_Faction_Join_Request]
				    , PlayerData[playerid][Character_Faction_Ban], PlayerData[playerid][Character_Money], PlayerData[playerid][Character_Coins], PlayerData[playerid][Character_Bank_Account], PlayerData[playerid][Character_Bank_Money]
				    , PlayerData[playerid][Character_Bank_Pin], PlayerData[playerid][Character_Bank_Loan], PlayerData[playerid][Character_VIP], PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]
				    , PlayerData[playerid][Character_Pos_Angle], PlayerData[playerid][Character_Interior_ID], PlayerData[playerid][Character_Virtual_World], PlayerData[playerid][Character_House_ID], PlayerData[playerid][Character_Total_Houses]
					, PlayerData[playerid][Character_Total_Businesses], PlayerData[playerid][Character_Business_ID], PlayerData[playerid][Character_Level], PlayerData[playerid][Character_Level_Exp]
					, PlayerData[playerid][Character_Name]);
					
    mysql_tquery(connection, playerquery);

	return 1;
}

forward Save_Character_Info_Query_2(playerid);
public Save_Character_Info_Query_2(playerid)
{
	new playerquery[2000];

	if(IsPlayerOnDuty[playerid] == 1)
	{
	    ResetPlayerWeapons(playerid);		
		
	    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
	    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
		GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
		GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
		GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
		GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);
	}

	GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
	GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
	GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
	GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
	GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
	GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

    mysql_format(connection, playerquery, sizeof(playerquery), "UPDATE `user_accounts` SET \
																	`character_ticket_amount` = '%i', \
																	`character_total_ticket_amount` = '%i', \
																	`character_jail` = '%i', \
																	`character_jail_time` = '%i', \
																	`character_jail_reason` = '%s', \
																	`character_last_crime` = '%s', \
																	`admin_level` = '%i', \
																 	`admin_level_exp` = '%i', \
																	`admin_jail` = '%i', \
																	`admin_jail_time` = '%i', \
																 	`admin_jail_reason` = '%s', \
																	`weapon_slot_1` = '%i', `weapon_slot_2` = '%i', `weapon_slot_3` = '%i', `weapon_slot_4` = '%i', `weapon_slot_5` = '%i', `weapon_slot_6` = '%i', \
																	`ammo_slot_1` = '%i', `ammo_slot_2` = '%i', `ammo_slot_3` = '%i', `ammo_slot_4` = '%i', `ammo_slot_5` = '%i', `ammo_slot_6` = '%i', \
																	`character_radio` = '%i', \
																	`character_has_rope` = '%i', \
																	`character_has_fuelcan` = '%i', \
																	`character_has_lockpick` = '%i', \
																	`character_has_device` = '%i', \
																	`character_has_drugs` = '%i', \
																	`character_has_food` = '%i', \
																	`character_has_mask` = '%i', \
																	`character_has_drinks` = '%i', \
																	`character_has_alcohol` = '%i', \
																	`character_has_phone` = '%i', \
																	`character_phonenumber` = '%i', \
																	`character_has_simcard` = '%i', `character_total_vehicles` = '%i' WHERE `character_name` = '%e' "

				    , PlayerData[playerid][Character_Ticket_Amount]
					, PlayerData[playerid][Character_Total_Ticket_Amount]
					, PlayerData[playerid][Character_Jail]
					, PlayerData[playerid][Character_Jail_Time]
					, PlayerData[playerid][Character_Jail_Reason]
					, PlayerData[playerid][Character_Last_Crime]
					, PlayerData[playerid][Admin_Level]
					, PlayerData[playerid][Admin_Level_Exp]
					, PlayerData[playerid][Admin_Jail]
					, PlayerData[playerid][Admin_Jail_Time]
					, PlayerData[playerid][Admin_Jail_Reason]
					, PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Weapon_Slot_6]
				    , PlayerData[playerid][Ammo_Slot_1], PlayerData[playerid][Ammo_Slot_2], PlayerData[playerid][Ammo_Slot_3], PlayerData[playerid][Ammo_Slot_4], PlayerData[playerid][Ammo_Slot_5], PlayerData[playerid][Ammo_Slot_6]
				    , PlayerData[playerid][Character_Radio]
					, PlayerData[playerid][Character_Has_Rope]
					, PlayerData[playerid][Character_Has_Fuelcan]
					, PlayerData[playerid][Character_Has_Lockpick]
					, PlayerData[playerid][Character_Has_Device]
					, PlayerData[playerid][Character_Has_Drugs]
					, PlayerData[playerid][Character_Has_Food]
					, PlayerData[playerid][Character_Has_Mask]
					, PlayerData[playerid][Character_Has_Drinks]
					, PlayerData[playerid][Character_Has_Alcohol]
					, PlayerData[playerid][Character_Has_Phone]
					, PlayerData[playerid][Character_Phonenumber]
					, PlayerData[playerid][Character_Has_SimCard]
					, PlayerData[playerid][Character_Total_Vehicles]
					, PlayerData[playerid][Character_Name]);

    mysql_tquery(connection, playerquery);
	return 1;
}

forward Save_Vehicle_Information();
public Save_Vehicle_Information()
{
	for(new i; i < MAX_VEHICLES; i ++)
	{
		new vehiclequery[2000];

	    mysql_format(connection, vehiclequery, sizeof(vehiclequery), "UPDATE `vehicle_information` SET \
																	`vehicle_faction` = '%i', \
																	`vehicle_job` = '%i', \
																	`vehicle_owner` = '%e', \
																	`vehicle_used` = '%i', \
																	`vehicle_model` = '%i', \
																	`vehicle_color_1` = '%i', \
																	`vehicle_color_2` = '%i', \
																	`vehicle_lock` = '%i', \
																	`vehicle_alarm` = '%i', \
																	`vehicle_gps` = '%i', \
																	`vehicle_fuel` = '%i' \
																	`vehicle_type` = '%i' WHERE `vehicle_id` = '%i' LIMIT 1"

						, VehicleData[i][Vehicle_Faction] , VehicleData[i][Vehicle_Job],  VehicleData[i][Vehicle_Owner] , VehicleData[i][Vehicle_Used] , VehicleData[i][Vehicle_Model] , VehicleData[i][Vehicle_Color_1] , VehicleData[i][Vehicle_Color_2]
						, VehicleData[i][Vehicle_Lock] , VehicleData[i][Vehicle_Alarm] , VehicleData[i][Vehicle_GPS], VehicleData[i][Vehicle_Fuel], VehicleData[i][Vehicle_Type]
						, VehicleData[i][Vehicle_ID]);

	    mysql_tquery(connection, vehiclequery);
	}
	return 1;
}

forward RegistrationSpawn(playerid);
public RegistrationSpawn(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw1);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw2);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw3);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw4);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw5);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw6);
	
    SpawnPlayer(playerid);
    TextDrawShowForPlayer(playerid, Time);
	StopAudioStreamForPlayer(playerid);
    
	SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_1],  -1877.8999,58.5820,1055.1891, 90);
	SpawnPlayer(playerid);
			
 	SetPlayerInterior(playerid, 14);
 	
 	HasPlayerFirstSpawned[playerid] = 1;
 	
 	PlayerData[playerid][Character_Money] =7500;
  	PlayerData[playerid][Character_Coins] +=20;
  	PlayerData[playerid][Character_Level] +=1;
  	
  	SetPlayerScore(playerid, PlayerData[playerid][Character_Level]);
  	SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
  	
  	SendClientMessage(playerid, COLOR_YELLOW, "Thank you for completing the registration of your character. For joining so early on in development, you");
  	SendClientMessage(playerid, COLOR_YELLOW, "have been given [20] coins and [$7500] in your wallet to get your character started!");
  	SendClientMessage(playerid, COLOR_YELLOW, "");
  	SendClientMessage(playerid, COLOR_YELLOW, "(Please take your time to go through our quick guides, that can be located at the front desk!)");

    TogglePlayerControllable(playerid,false);

    Minute_Timer[playerid] = SetTimerEx("MinuteTimer", 60000, true, "i", playerid);
    DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
	return 1;
}

forward LoginSpawn(playerid);
public LoginSpawn(playerid)
{
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw1);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw2);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw3);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw4);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw5);
	PlayerTextDrawHide(playerid, PlayerText:LoginTextdraw6);
	
	SetPlayerColor(playerid, COLOR_WHITE);
	StopAudioStreamForPlayer(playerid);
	
    TextDrawShowForPlayer(playerid, Time);
    
    SetPlayerScore(playerid, PlayerData[playerid][Character_Level]);
	SetPlayerHealth(playerid, PlayerData[playerid][Character_Health]);
	SetPlayerArmour(playerid, PlayerData[playerid][Character_Armor]);
	
	HasPlayerFirstSpawned[playerid] = 1;
    
    if(PlayerData[playerid][Character_Registered] == 1)
    {
        new dstring[256];
       	if(PlayerData[playerid][Admin_Jail] == 1)
        {
			format(dstring, sizeof(dstring), "[SERVER]: {FFFFFF}You never completed your admin jail sentence. Please finish your remaining ( %i ) minutes!", PlayerData[playerid][Admin_Jail_Time]);
			SendClientMessage(playerid, COLOR_RED, dstring);

			SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this jail sentence, by reporting this on the forums!");
			
			SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  340.2295, 163.5576, 1019.9912+1, 0.8699);
			SpawnPlayer(playerid);

			SetPlayerSkin(playerid, 62);

			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, playerid++);

			TogglePlayerControllable(playerid,false);
			printf("[Login Spawn] %s has been spawned at the admin jail to finish their sentence", GetName(playerid));
        }
        else if(PlayerData[playerid][Character_Jail] > 0)
        {
			format(dstring, sizeof(dstring), "[SERVER]: {FFFFFF}You never completed your prison sentence. Please finish your remaining ( %i ) minutes!", PlayerData[playerid][Character_Jail_Time]);
			SendClientMessage(playerid, COLOR_RED, dstring);

			SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this jail sentence, by reporting this on the forums!");

            new randIndex = random(sizeof(PoliceJailSpawns));			
			SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  PoliceJailSpawns[randIndex][0], PoliceJailSpawns[randIndex][1], PoliceJailSpawns[randIndex][2]+1, 90);
			SpawnPlayer(playerid);

			SetPlayerInterior(playerid, 6);
			SetPlayerVirtualWorld(playerid, 1);

			TogglePlayerControllable(playerid,false);
			printf("[Login Spawn] %s has been spawned at the jail cell to finish their sentence", GetName(playerid));
        }
        else if(PlayerData[playerid][Character_House_ID] > 0 && PlayerData[playerid][Character_Last_Login] != SERVER_HOUR && PlayerData[playerid][Admin_Jail] == 0)
		{
		    new houseid = PlayerData[playerid][Character_House_ID];
			
			SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z]+1, HouseData[houseid][House_Spawn_A]);
			SpawnPlayer(playerid);

			SetPlayerInterior(playerid, HouseData[houseid][House_Spawn_Interior]);
			SetPlayerVirtualWorld(playerid, HouseData[houseid][House_Spawn_VW]);

			SendClientMessage(playerid, COLOR_YELLOW, "Thank you for logging back into the server, you have been spawned at your house!");
			
			if(GetPlayerSkin(playerid) == 0)
			{
			    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
				printf("[Login] %s has spawned with CJ skin, updated there skin", GetName(playerid));
			}

			TogglePlayerControllable(playerid,false);
			printf("[Login Spawn] %s has been spawned at their house", GetName(playerid));
		}
		else if(PlayerData[playerid][Character_Hotel_ID] > 0 && PlayerData[playerid][Character_Last_Login] != SERVER_HOUR && PlayerData[playerid][Admin_Jail] == 0)
		{			
			SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  PlayerData[playerid][Hotel_Character_Pos_X], PlayerData[playerid][Hotel_Character_Pos_Y], PlayerData[playerid][Hotel_Character_Pos_Z]+1, PlayerData[playerid][Hotel_Character_Pos_Angle]);
			SpawnPlayer(playerid);

			SetPlayerInterior(playerid, PlayerData[playerid][Hotel_Character_Interior_ID]);
			SetPlayerVirtualWorld(playerid, PlayerData[playerid][Hotel_Character_Virtual_World]);

			SendClientMessage(playerid, COLOR_YELLOW, "Thank you for logging back into the server, you have been spawned at your hotel!");
			
			if(GetPlayerSkin(playerid) == 0)
			{
			    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
				printf("[Login] %s has spawned with CJ skin, updated there skin", GetName(playerid));
			}

			TogglePlayerControllable(playerid,false);
			printf("[Login Spawn] %s has been spawned at their hotel", GetName(playerid));
		}
		else if(PlayerData[playerid][Character_House_ID] > 0 && PlayerData[playerid][Character_Last_Login] == SERVER_HOUR && PlayerData[playerid][Admin_Jail] == 0)
		{
		    if(PlayerData[playerid][Character_Pos_X] == 0 && PlayerData[playerid][Character_Pos_Y] == 0 && PlayerData[playerid][Character_Pos_Z] == 0)
			{
				SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  1529.6, -1691.2, 14.3, PlayerData[playerid][Character_Pos_Angle]);
				SpawnPlayer(playerid);
				
				SetPlayerInterior(playerid, 0);
			    SetPlayerVirtualWorld(playerid, 0);

				SendClientMessage(playerid, COLOR_YELLOW, "Your account was bugged when saving your last cords. You have been spawned in LS for the time being!");
				
				if(GetPlayerSkin(playerid) == 0)
				{
				    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
					printf("[Login] %s has spawned with CJ skin, updated there skin", GetName(playerid));
				}

				TogglePlayerControllable(playerid,false);
				printf("[Login Spawn] %s has bug spawned, they have been sent to LS", GetName(playerid));
			}
			else
			{				
				SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]+1, PlayerData[playerid][Character_Pos_Angle]);
				SpawnPlayer(playerid);

				SetPlayerInterior(playerid, PlayerData[playerid][Character_Interior_ID]);
				SetPlayerVirtualWorld(playerid, PlayerData[playerid][Character_Virtual_World]);

				SendClientMessage(playerid, COLOR_YELLOW, "Thank you for logging back into the server, you have been spawned at your last logout point!");
				
				SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_Logout]);
				if(GetPlayerSkin(playerid) == 0)
				{
				    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
					printf("[Login] %s has spawned with CJ skin, updated there skin", GetName(playerid));
				}

				TogglePlayerControllable(playerid,false);
				printf("[Login Spawn] %s has spawned in their last location", GetName(playerid));
			}
		}
		else if(PlayerData[playerid][Character_House_ID] == 0 && PlayerData[playerid][Admin_Jail] == 0)
	    {			
			SetSpawnInfo(playerid, NO_TEAM, PlayerData[playerid][Character_Skin_Logout],  PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]+1, PlayerData[playerid][Character_Pos_Angle]);
			SpawnPlayer(playerid);

			SetPlayerInterior(playerid, PlayerData[playerid][Character_Interior_ID]);
			SetPlayerVirtualWorld(playerid, PlayerData[playerid][Character_Virtual_World]);

			SendClientMessage(playerid, COLOR_YELLOW, "Thank you for logging back into the server, you have been spawned at your last logout point!");
			
			if(GetPlayerSkin(playerid) == 0)
			{
			    SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);
				printf("[Login] %s has spawned with CJ skin, updated there skin", GetName(playerid));
			}

			TogglePlayerControllable(playerid,false);
			printf("[Login Spawn] %s has spawned in their last location", GetName(playerid));
		}
		else if(PlayerData[playerid][Character_Health] <= 5)
		{
		    IsPlayerInHospital[playerid] = 1;

			SetSpawnInfo(playerid, NO_TEAM, 62,  -1122.5582,1977.2639,-58.9141, 235.7789);
			SpawnPlayer(playerid);

		 	SetPlayerInterior(playerid, 0);

		 	SetPlayerHealth(playerid, 50);

	        ClearMessages(playerid);
		 	SendClientMessage(playerid, COLOR_YELLOW, "Your character has just died [BUG MAYBE?], please wait inside the hospital until your rest period is up!");
		
			printf("[Login Spawn] %s has bug spawned and has been put in the hospital", GetName(playerid));

		 	Hospital_Timer[playerid] = SetTimerEx("HospitalTimer", 60000, false, "i", playerid);
		}

		Minute_Timer[playerid] = SetTimerEx("MinuteTimer", 60000, true, "i", playerid);
		DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
    }
    
    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
	GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
	GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
	GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
	GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
	GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);
    
    WhoIsCalling[playerid] = 9999999;
    
	return 1;
}

forward OnBanCheck(playerid);
public OnBanCheck(playerid)
{
    if(cache_num_rows() > 0)
    {
        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]: %s has just been offline banned by %s", BanName[playerid], GetName(playerid));
		SendClientMessageToAll(COLOR_RED, dstring);	
		
		new updatequery[2000];
		mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_ban` = 1 WHERE `character_name` = '%e' LIMIT 1", BanName[playerid]);
		mysql_tquery(connection, updatequery);
		
		BanName[playerid] = "";
	}
	else
	{
		SendPlayerErrorMessage(playerid, " The name you have entered cannot be banned! [Already has been banned or doesn't exist]");
		
		BanName[playerid] = "";
	}	
    return 1;
}

forward OnUnbanCheck(playerid);
public OnUnbanCheck(playerid)
{
    if(cache_num_rows() > 0)
    {
        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]: %s has just been offline unbanned by %s", BanName[playerid], GetName(playerid));
		SendClientMessageToAll(COLOR_RED, dstring);	
		
		new updatequery[2000];
		mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_ban` = 0 WHERE `character_name` = '%e' LIMIT 1", BanName[playerid]);
		mysql_tquery(connection, updatequery);
		
		BanName[playerid] = "";
	}
	else
	{
		SendPlayerErrorMessage(playerid, " The name you have entered cannot be unbanned! [Already has been unbanned or doesn't exist]");
		
		BanName[playerid] = "";
	}	
    return 1;
}

forward CheckUserMoney(playerid);
public CheckUserMoney(playerid)
{
    if (GetPlayerMoney(playerid) != PlayerData[playerid][Character_Money])
	{
		ResetPlayerMoney(playerid);
  		GivePlayerMoney(playerid, PlayerData[playerid][Character_Money]);
	}
	return 1;
}
forward OnBillPay(playerid);
public OnBillPay(playerid)
{
    new billID, billAmount, billName[50], billCharacterName[50];

    if (cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "bill_id", billID);
		cache_get_value_name(0, "character_name", billCharacterName, 50);
		
		cache_get_value_name(0, "bill_name", billName, 50);
		cache_get_value_name_int(0, "bill_amount", billAmount);

		if(strcmp(billCharacterName, PlayerData[playerid][Character_Name]) == 0)
		{
		    if(PlayerData[playerid][Character_Money] >= billAmount)
		    {
		        new onlineplayer;
		        
		        onlineplayer = 999;
		        
                for(new i = 0; i < MAX_PLAYERS; i++)
        		{
        		    if(strcmp(PlayerData[i][Character_Name], billName, false) == 0)
        		    {
        		        onlineplayer = i;
        		    }
        		}
        		
        		if(onlineplayer >= 0 && onlineplayer < 999)
        		{
        		    PlayerData[onlineplayer][Character_Money] += billAmount;
        		    PlayerData[playerid][Character_Money] -= billAmount;
        		    
        		    new dstring[256];
					format(dstring, sizeof(dstring), "> You have just paid a bill of $%i, to %s!", billAmount, GetName(onlineplayer));
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "> You have just been paid for a bill of $%i, from %s!", billAmount, GetName(playerid));
					SendClientMessage(onlineplayer, COLOR_YELLOW, dstring);
					
					new acquery[2000];
			        mysql_format(connection, acquery, sizeof(acquery), "DELETE FROM `bill_information` WHERE `bill_id` = '%d' LIMIT 1", billID);
		    		mysql_tquery(connection, acquery);
        		}
        		else if(onlineplayer == 999)
        		{
        		    PlayerData[playerid][Character_Money] -= billAmount;
        		    
	  				new acquery[2000];
			        mysql_format(connection, acquery, sizeof(acquery), "UPDATE `user_accounts` SET `character_money` = character_money + '%d' WHERE `character_name` = '%e' LIMIT 1", billAmount, billName);
		    		mysql_tquery(connection, acquery);
				}
			}
			else return SendPlayerErrorMessage(playerid, " You do not have enough money to pay this bill!");
		}
    }
    else
    {
        SendPlayerErrorMessage(playerid, " There are no records found for this bill ID!");
    }

    return 1;
}

forward OnReportCloseCheck(playerid);
public OnReportCloseCheck(playerid)
{
	new reportID, dstring[256];
	
    if (cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "report_id", reportID);
        
        new acquery[2000];
       	mysql_format(connection, acquery, sizeof(acquery), "UPDATE `report_information` SET `report_status` = '1' WHERE `report_id` = '%d' LIMIT 1", reportID);
		mysql_tquery(connection, acquery);
		
		format(dstring, sizeof(dstring), "[REPORT CLOSED]:{FFFFFF} %s has just closed report id: %d", GetName(playerid), reportID);
		SendReportMessage(COLOR_AQUABLUE, dstring);
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "> There are no current active reports with this ID");
    }

    return 1;
}

forward OnLoanCheckCustomer(playerid);
public OnLoanCheckCustomer(playerid)
{
    if (cache_num_rows() > 0)
    {
        new loanRow[1024];
        new loanHeader[256];
        new loanDetails[1280];
        
        new loanName[50], loanReason[50];
        new loanAmount, loanID;

        loanRow[0] = '\0';

        for (new i = 0; i < cache_num_rows(); i++)
        {
			cache_get_value_name_int(i, "loan_id", loanID);
			
			cache_get_value_name_int(i, "loan_amount", loanAmount);
			cache_get_value_name(i, "loan_name", loanName, 50);
			cache_get_value_name(i, "loan_reason", loanReason, 50);

            new tempRow[256];
            format(tempRow, sizeof(tempRow), "%d\t%s\t%d\tNot Reviewed\n", loanID, loanName, loanAmount);

            strcat(loanRow, tempRow);
        }

        format(loanHeader, sizeof(loanHeader), "Loan ID\tApplicant Name\tLoan Amount\tLoan Status\n");
        format(loanDetails, sizeof(loanDetails), "%s%s", loanHeader, loanRow);

        ShowPlayerDialog(playerid, DIALOG_BANK_VIEW_LOANS, DIALOG_STYLE_TABLIST_HEADERS, "Los Santos Bank - Loan Applications", loanDetails, "Go Back", "");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_BANK_VIEW_LOANS, DIALOG_STYLE_TABLIST_HEADERS, "Los Santos Bank - Loan Applications", "No avaliable loans", "Go Back", "");
    }
    return 1;
}

forward OnLoanCheck(playerid);
public OnLoanCheck(playerid)
{
    if (cache_num_rows() > 0)
    {
        new loanRow[1024];
        new loanHeader[256];
        new loanDetails[1280];

        loanRow[0] = '\0';

        for (new i = 0; i < cache_num_rows(); i++)
        {
			new loaded;
			
			cache_get_value_name_int(i, "loan_id", loaded);
			LoanData[loaded][Loan_ID] = loaded;
			
			cache_get_value_name_int(i, "loan_amount", LoanData[loaded][Loan_Amount]);
			cache_get_value_name(i, "loan_name", LoanData[loaded][Loan_Name], 50);
			cache_get_value_name(i, "loan_reason", LoanData[loaded][Loan_Reason], 50);
			cache_get_value_name_int(i, "loan_status", LoanData[loaded][Loan_Status]);
            
            SQL_LOAN_ID[playerid][i] = loaded;
            SQL_LOAN_AMOUNT[playerid][i] = LoanData[loaded][Loan_Amount];

            new tempRow[256];
            format(tempRow, sizeof(tempRow), "%d\t%s\t%d\n", LoanData[loaded][Loan_ID], LoanData[loaded][Loan_Name], LoanData[loaded][Loan_Amount]);

            strcat(loanRow, tempRow);
        }

        format(loanHeader, sizeof(loanHeader), "Loan ID\tApplicant Name\tLoan Amount\n");
        format(loanDetails, sizeof(loanDetails), "%s%s", loanHeader, loanRow);

        ShowPlayerDialog(playerid, DIALOG_BANK_FAC_LOANS, DIALOG_STYLE_TABLIST_HEADERS, "Los Santos Bank - Loan Applications", loanDetails, "View", "Exit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_BANK_FAC_NOLOANS, DIALOG_STYLE_TABLIST_HEADERS, "Los Santos Bank - Loan Applications", "No avaliable loans", "Close", "");
    }
    return 1;
}

forward OnLoanDetails(playerid);
public OnLoanDetails(playerid)
{
    if (cache_num_rows() > 0)
    {
        new loanName[50], loanReason[50], status[50];
        new loanAmount, loanStatus;

		cache_get_value_name_int(0, "loan_amount", loanAmount);
		cache_get_value_name(0, "loan_name", loanName, 50);
		cache_get_value_name(0, "loan_reason", loanReason, 50);
		cache_get_value_name_int(0, "loan_status", loanStatus);
		
		cache_get_value_name(0, "loan_name", SQL_LOAN_NAME[playerid][0], 50);
        
        new name[50];
        format(name, sizeof(name), "%s", SQL_LOAN_NAME[playerid][0]);
	    SelectedLoanName[playerid] = name;
        
        if(loanStatus == 0) { format(status, sizeof(status), "Open"); }

        new loanDetails[500];
        format(loanDetails, sizeof(loanDetails), "You are viewing Los Santos Bank Loan Application ID: %d\n\nCustomer Name:   %s\nAmount:                $%d\nReason:                 %s\nStatus:                   %s\n\nPlease make sure you are very careful with what loans you are approving, you\nhave limited funds.", SelectedLoanID, loanName, loanAmount, loanReason, status);

        ShowPlayerDialog(playerid, DIALOG_BANK_FAC_LOAN_INFO, DIALOG_STYLE_MSGBOX, "Los Santos Bank - Loan Details", loanDetails, "Proceed", "Go Back");
    }
    return 1;
}

forward OnFactionCheck(playerid);
public OnFactionCheck(playerid)
{
    new stringtitle[256];
    new FactionID, FactionName[50];

    SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Server Factions{FFFFFF} ***");

    if (cache_num_rows() > 0)
    {
        for (new i = 0; i < cache_num_rows(); i++)
        {			
			cache_get_value_name_int(i, "faction_id", FactionID);
			cache_get_value_name(i, "faction_name", FactionName, 50);

			format(stringtitle, sizeof(stringtitle), "> {F2F746}Faction ID:{FFFFFF} %d - {F2F746}Faction Name:{FFFFFF} %s", FactionID, FactionName);
   			SendClientMessage(playerid, COLOR_WHITE, stringtitle);

   			SendClientMessage(playerid, COLOR_WHITE, "-----------------------------------");
        }
    }
    return 1;
}

forward OnReportCheck(playerid);
public OnReportCheck(playerid)
{
    new stringtitle[256], stringdetails[256];
    new reportID, reportName[50], reportTarget[50], reportReason[256];

    SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Current Active Reports{FFFFFF} ***");

    if (cache_num_rows() > 0)
    {
        for (new i = 0; i < cache_num_rows(); i++)
        {			
			cache_get_value_name_int(i, "report_id", reportID);
			cache_get_value_name(i, "character_name", reportName, 50);
			cache_get_value_name(i, "target_name", reportTarget, 50);
			cache_get_value_name(i, "reason", reportReason, 256);

			format(stringtitle, sizeof(stringtitle), "> {F2F746}Report ID:{FFFFFF} %d - {F2F746}Reportee Name:{FFFFFF} %s - {F2F746}Reported Name:{FFFFFF} %s", reportID, reportName, reportTarget);
   			SendClientMessage(playerid, COLOR_WHITE, stringtitle);
   			format(stringdetails, sizeof(stringdetails), "> {F2F746}Reason:{FFFFFF} %s", reportReason);
   			SendClientMessage(playerid, COLOR_WHITE, stringdetails);
   			SendClientMessage(playerid, COLOR_WHITE, "-----------------------------------");
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "> There are no current active reports");
    }

    return 1;
}

forward OnBillCheck(playerid);
public OnBillCheck(playerid)
{
    new string[256], btext[50];
    new billID, billAmount, billType, billName[50], billCharacterName[50];

    SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Here is a list of your bills{FFFFFF} ***");

    if (cache_num_rows() > 0)
    {
        for (new i = 0; i < cache_num_rows(); i++)
        {			
			cache_get_value_name_int(i, "bill_id", billID);
			cache_get_value_name(i, "character_name", billCharacterName, 50);
			cache_get_value_name_int(i, "bill_amount", billAmount);
			cache_get_value_name_int(i, "bill_type", billType);
			
			if(strcmp(billCharacterName, PlayerData[playerid][Character_Name]) == 0)
			{
				switch(billType)
				{
				    case 0: { btext = "LSPD Bill"; }
				    case 1: { btext = "LSPD Bill"; }
				    case 2: { btext = "LSPD Bill"; }
				    case 3: { btext = "LSPD Bill"; }
				    case 4: { btext = "LSPD Bill"; }
				    case 5: { btext = "LSPD Bill"; }
				    case 6: { btext = "LSPD Bill"; }
				    case 7: { btext = "LSPD Bill"; }
				    case 9: { btext = "Mechanic Bill"; }
				}

	            format(string, sizeof(string), "> {F2F746}Bill ID:{FFFFFF} %d - {F2F746}Amount:{FFFFFF} $%d - {F2F746}Type:{FFFFFF} %s - {F2F746}Charged By:{FFFFFF} %s", billID, billAmount, btext, billName);
	            SendClientMessage(playerid, COLOR_WHITE, string);
			}
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "> You don't have any bills");
    }

    return 1;
}

forward GetNextPhoneNumber(playerid);
public GetNextPhoneNumber(playerid)
{
    if(cache_num_rows() > 0)
    {
        SQL_PHONENUMBER_USED = 0;
    }
    else
	{
		SQL_PHONENUMBER_USED = 1;
	}
    return 1;
}

forward HospitalTimer(playerid);
public HospitalTimer(playerid)
{
 	IsPlayerInHospital[playerid] = 0;
	PlayerData[playerid][Character_Money] -=250;

	SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}You can now leave the Los Santos General Hospital - A fee of $250 has been taken from your account!");
	SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}Use /change to change your outfits!");
	return 1;
}

forward SaveImportantParameters(playerid);
public SaveImportantParameters(playerid)
{
    SendGlobalServerMessage("Global Script Saving In Progress - There is only one minute left until the restart!");
    
    for(new i = 0; i < MAX_PLAYERS; i++)
  	{
		OnPlayerDisconnect(i, 1);
  	}

    Save_Vehicle_Information();
	return 1;
}

forward ServerRestart(playerid);
public ServerRestart(playerid)
{
    mysql_close(connection);
    SendRconCommand("gmx");
	return 1;
}

forward RefuelTimer(playerid);
public RefuelTimer(playerid)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
    	new vehicle = GetPlayerVehicleID(playerid);
    	new litrecount, difference, costfuel;
    	
    	litrecount = VehicleData[vehicle][Vehicle_Fuel];

		difference = 100 - litrecount;
		costfuel = difference * 2;
		
		if(PlayerData[playerid][Character_Money] >= costfuel)
		{
		    new string[256];
		    
		    PlayerData[playerid][Character_Money] -= costfuel;
		    VehicleData[vehicle][Vehicle_Fuel] = 100;
		    
		    format(string, sizeof(string), "> %s has just filled up their vehicle", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

			format(string, sizeof(string), "> You have just filled up your vehicle with a cost of $%i!", costfuel);
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else
		{
		    new string[256];
		    format(string, sizeof(string), "[ERROR]:{FFFFFF} You cannot afford to fill up you vehicle at this time. It will cost you $%i!", costfuel);
			SendClientMessage(playerid, COLOR_PINK, string);
		}
    }
    return 1;
}

forward VehicleTimer(playerid);
public VehicleTimer(playerid)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
    	new vehicle = GetPlayerVehicleID(playerid);
    	new Float:vehiclehealth;

		GetVehicleHealth(vehicle, vehiclehealth);

        new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);

		if(vehiclehealth > 300)
		{
			if(engine == 1)
			{
		        new vehiclefuel[24];
				format(vehiclefuel, sizeof(vehiclefuel), "%d", VehicleData[vehicle][Vehicle_Fuel]);
				PlayerTextDrawSetString(playerid, SpeedBoxFuelAmount, vehiclefuel);
			}

			new speed[24];
			format(speed, sizeof(speed), "%i", GetVehicleSpeed(vehicle));
			PlayerTextDrawSetString(playerid, SpeedBoxSpeedAmount, speed);
		}
		else if(vehiclehealth <= 300)
		{
		    new string[156];

			if(engine == 1)
			{
				SetVehicleParamsEx(vehicle, false, lights, alarm, doors, bonnet, boot, objective);

			    format(string, sizeof(string), "> %s's vehicle has just turned off due to high damage", GetName(playerid));
	   			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

   				PlayerTextDrawSetString(playerid, SpeedBoxFuelAmount, "-");

   				KillTimer(Fuel_Timer[playerid]);
   				KillTimer(Vehicle_Timer[playerid]);

   				Fuel_Timer[playerid] = 0;
				Vehicle_Timer[playerid] = 0;

				printf("vehicle has turned off due to high damage");
			}
		}
    }
    return 1;
}

forward FuelTimer(playerid);
public FuelTimer(playerid)
{
 	new i = GetPlayerVehicleID(playerid);
 	
	if(VehicleData[i][Vehicle_Fuel] > 1)
	{
	    VehicleData[i][Vehicle_Fuel] -= 1;
	}
	return 1;
}

forward FlashLights(vehicleid);
public FlashLights(vehicleid) 
{
    new VEHICLE_PANEL_STATUS:panels, VEHICLE_DOOR_STATUS:doors, VEHICLE_LIGHT_STATUS:lights, VEHICLE_TIRE_STATUS:tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    switch(Vehicle_Flash[vehicleid])
    {
        case 0: { lights = VEHICLE_LIGHT_STATUS:1; UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires); }
 
        case 1: { lights = VEHICLE_LIGHT_STATUS:4; UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires); }
    }

    if(Vehicle_Flash[vehicleid] >=2) 
	{
		Vehicle_Flash[vehicleid] = 0;
	}
    else 
	{
		Vehicle_Flash[vehicleid] ++;
	}
	return 1;
}

forward AssistanceTimer(playerid);
public AssistanceTimer(playerid)
{
	HasPlayerRequestAssistance[playerid] = 0;
	return 1;
}

forward DrugBakingCooldownTimer(playerid);
public DrugBakingCooldownTimer(playerid)
{
	HasPlayerBakedDrugs[playerid] = 0;
	return 1;
}

forward DrugBakingHeroin(playerid);
public DrugBakingHeroin(playerid)
{
	if(HasPlayerBakedDrugs[playerid] == 1)
	{
		TogglePlayerControllable(playerid, true);
		
		PlayerData[playerid][Character_Has_Drugs] -= 2;
		PlayerData[playerid][Character_Drug_Heroin] += 12;
						
		new updatequery[2000];
		mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_drug_heroin` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Drug_Heroin], GetName(playerid));
		mysql_tquery(connection, updatequery);
							
		new string[256];
		format(string, sizeof(string), "> %s has successfully created some heroin drugs", GetName(playerid));
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, false, false, false, false, 0, SYNC_ALL);
							
		new dstring[256];
		format(dstring, sizeof(dstring), "- You have just obtained 12 heorin packets, you can either /giveitem or /usedrugs!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring);
							
		DrugBaking_Timer[playerid] = SetTimerEx("DrugBakingTimer", 600000, false, "i", playerid);
	}
	return 1;
}

forward DrugBakingCocaine(playerid);
public DrugBakingCocaine(playerid)
{
	if(HasPlayerBakedDrugs[playerid] == 1)
	{
		TogglePlayerControllable(playerid, true);
		
		PlayerData[playerid][Character_Has_Drugs] -= 1;
		PlayerData[playerid][Character_Drug_Cocaine] += 20;
						
		new updatequery[2000];
		mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_drug_cocaine` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Drug_Cocaine], GetName(playerid));
		mysql_tquery(connection, updatequery);
							
		new string[256];
		format(string, sizeof(string), "> %s has successfully created some cocaine drugs", GetName(playerid));
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, false, false, false, false, 0, SYNC_ALL);
							
		new dstring[256];
		format(dstring, sizeof(dstring), "- You have just obtained 20 cocaine packets, you can either /givedrugs or /usedrugs!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring);
							
		DrugBaking_Timer[playerid] = SetTimerEx("DrugBakingCooldownTimer", 600000, false, "i", playerid);
	}
	return 1;
}

forward DrugUseCooldown(playerid);
public DrugUseCooldown(playerid)
{
	new weather;
	weather = GetWeather();
	
	SetPlayerWeather(playerid, weather);
	SetPlayerDrunkLevel(playerid, 0);
	ClearAnimations(playerid);
	return 1;
}

forward CrackDealerCooldownTimer(playerid);
public CrackDealerCooldownTimer(playerid)
{
	if(HasPlayerTakenDrugs[playerid] == 1)
	{
		HasPlayerTakenDrugs[playerid] = 0;
	}
	return 1;
}

forward Cooldown_Helpme_Timer(playerid);
public Cooldown_Helpme_Timer(playerid)
{
	if(IsPlayerInHelpMeCooldown[playerid] == 1)
	{
		IsPlayerInHelpMeCooldown[playerid] = 0;
	}
	return 1;
}

forward HotWireTimer(playerid);
public HotWireTimer(playerid)
{
	if(IsPlayerStealingCar[playerid] > 0)
	{
		new vid;
		new Float:vPos[3];

		vid = GetClosestVehicle(playerid);
		GetVehiclePos(vid, vPos[0],vPos[1],vPos[2]);
		
		ClearAnimations(playerid);
		
		PutPlayerInVehicle(playerid, vid, 0);

        new string[256];
		format(string, sizeof(string), "> %s has successfully broken into a vehicle", GetName(playerid));
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	}
	return 1;
}

forward RepairTimer(playerid);
public RepairTimer(playerid)
{
	if(PlayerData[playerid][Character_Faction] == 8 && DudefixJob == 1 && DudefixJobAccepted == 1)
	{
	    ClearAnimations(playerid);
	    
     	DestroyDynamicObject(DudeFixObjectOne);
     	DestroyDynamicObject(DudeFixObjectTwo);
     	DestroyDynamicObject(DudeFixObjectThree);
     	DestroyDynamicObject(DudeFixObjectFour);
     	
     	DudefixJob = 0;
     	DudefixJobAccepted = 0;
		DudefixJobID = 0;
		
		DudefixJobTimer = 0;
		DudefixJobTimerExp = 0;

	    for (new i = 0; i < MAX_PLAYERS; i++)
		{
			DudefixJobPlayer[playerid] = 0;
		}

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: An Engineer has completed a pipe repair job. Well done %s!)", GetName(playerid));
		SendFactionRadioMessage(8, COLOR_WHITE, dstring);

		PlayerData[playerid][Character_Money] += 6000;

		print("Dudefix Job Completed");

        KillTimer(Repair_Timer[playerid]);
        Repair_Timer[playerid] = 0;
	}
    if(PlayerData[playerid][Character_Faction] == 9 && MechanicJob == 1 && MechanicJobAccepted == 1)
	{
		if(MechanicJobHealth < 100)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 10.0, VehicleData[MechanicJobID][Vehicle_Spawn_X], VehicleData[MechanicJobID][Vehicle_Spawn_Y], VehicleData[MechanicJobID][Vehicle_Spawn_Z]))
		    {
		        MechanicJobHealth += 10;

                new dstring[256];
				format(dstring, sizeof(dstring), "> Vehicle Repair Status: %d/100", MechanicJobHealth);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

		        printf("Mechanic Job Repair Status: %d", MechanicJobHealth);
		    }
		}
		else if(MechanicJobHealth == 100)
		{
		    MechanicJob = 0;
		    MechanicJobHealth = 0;
		    MechanicJobID = 0;
			MechanicJobAccepted = 0;

		    for (new i = 0; i < MAX_PLAYERS; i++)
			{
				MechanicJobPlayer[playerid] = 0;
			}

		    new dstring[256];
			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: A mechanic has completed a vehicle repair job. Well done %s!)", GetName(playerid));
			SendFactionRadioMessage(9, COLOR_WHITE, dstring);

			PlayerData[playerid][Character_Money] += 3500;
			
		    ClearAnimations(playerid);
            TogglePlayerControllable(playerid, true);

			print("Mechanic Job Completed");

            KillTimer(Repair_Timer[playerid]);
            Repair_Timer[playerid] = 0;
		}
	}
	return 1;
}

forward MinuteTimer();
public MinuteTimer()
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{ 
			if(PlayerData[i][Character_Minutes] == 60)
		    {
		        CallPayDayCheck(i);
		        
		        PlayerData[i][Character_Minutes] = 0;
		        PlayerData[i][Character_Level_Exp] += 1;
		    }
		    if(PlayerData[i][Character_Minutes] >= 0 )
		    {
		        PlayerData[i][Character_Minutes] += 1;
		    }
		    if(PlayerData[i][Admin_Jail_Time] > 0)
		    {
		        PlayerData[i][Admin_Jail_Time] --;
		    }
		    if(PlayerData[i][Character_Jail_Time] > 0)
		    {
		        PlayerData[i][Character_Jail_Time] --;
		    }
		    if(PlayerData[i][Admin_Jail_Time] == 0 && PlayerData[i][Admin_Jail] == 1)
		    {
		        new emptystring[50] = "";

				PlayerData[i][Admin_Jail] = 0;
				PlayerData[i][Admin_Jail_Time] = 0;
				PlayerData[i][Admin_Jail_Reason] = emptystring;
				
		        SetPlayerPos(i, 811.2561, -1098.2684, 25.9063);
				SetPlayerFacingAngle(i, 240.8300);

				SetPlayerInterior(i, 0);
				SetPlayerVirtualWorld(i, 0);
				
				SetPlayerSkin(i, PlayerData[i][Character_Skin_1]);

				SendClientMessage(i, COLOR_RED, "[SERVER]: {FFFFFF}You have just completed your admin jail sentence. You have been spawned at the Los Santos Cemetery with you Preset Skin!");
		    }
		    if(PlayerData[i][Character_Jail_Time] == 0 && PlayerData[i][Character_Jail] == 1)
		    {
		        new emptystring[50] = "";

                PlayerData[i][Character_Jail] = 0;
				PlayerData[i][Character_Jail_Time] = 0;
				PlayerData[i][Character_Jail_Reason] = emptystring;

		        SetPlayerPos(i, 1489.0377,-1720.4855,8.2340);
				SetPlayerFacingAngle(i, 169.0772);

				SetPlayerInterior(i, 0);
				SetPlayerVirtualWorld(i, 0);

				SetPlayerSkin(i, PlayerData[i][Character_Skin_1]);

				SendClientMessage(i, COLOR_RED, "[SERVER]: {FFFFFF}You have just completed your prison sentence, you will have police follow up upon your release!");
		    }
		}
	}
	return 1;
}

forward CallPayDayCheck(playerid);
public CallPayDayCheck(playerid)
{
	if(PlayerData[playerid][Character_Level] >= 0)
	{
	    new paydaystd, paydayamt, dstring[256], vstring[256], tstring[256];

		paydayamt = 0;
		paydaystd = 1500;
		
		format(tstring,sizeof(tstring),"*** {33CC99}%s Paycheck{FFFFFF} ***", GetName(playerid));
		SendClientMessage(playerid, COLOR_WHITE, tstring);

     	if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] == 0)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.05);
			PlayerData[playerid][Character_Money] += paydayamt;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);

     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 1)
		{
			paydayamt = paydaystd + floatround(paydaystd * 0.10);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 2)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.12);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 3)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.15);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 4)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.18);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 5)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.25);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    else if(PlayerData[playerid][Character_Level] >= 0 && PlayerData[playerid][Character_Faction] > 0 && PlayerData[playerid][Character_Faction_Rank] == 6)
	    {
			paydayamt = paydaystd + floatround(paydaystd * 0.30);
			PlayerData[playerid][Character_Money] += paydayamt;

			PlayerData[playerid][Character_Coins] += 1;

            format(dstring,sizeof(dstring),"{33CC99}[Earnings]:{FFFFFF} $%d ", paydayamt);
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
     		
     		if(PlayerData[playerid][Character_VIP] == 1)
			{
			    PlayerData[playerid][Character_Coins] += 3;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Three Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 2)
			{
			    PlayerData[playerid][Character_Coins] += 5;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Five Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else if(PlayerData[playerid][Character_VIP] == 3)
			{
			    PlayerData[playerid][Character_Coins] += 10;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} Ten Coins");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
			else
			{
			    PlayerData[playerid][Character_Coins] += 1;

			    format(vstring,sizeof(vstring),"{33CC99}[Non-VIP]:{FFFFFF} One Coin");
     			SendClientMessage(playerid, COLOR_YELLOW, vstring);
			}
	    }
	    SendClientMessage(playerid, COLOR_WHITE, "-----------------------------------");
	}
	return 1;
}

forward DoorDelayTimer(playerid);
public DoorDelayTimer(playerid)
{
 	TogglePlayerControllable(playerid,true);
	return 1;
}

forward DragTimer();
public DragTimer()
{
 	for(new i; i < MAX_PLAYERS; i ++)
	{
	    new targetid;
	    targetid = WhoIsDragging[i];
	    
	    new Float:x, Float:y, Float:z;
	    
	    GetPlayerPos(targetid, x, y, z);
	    SetPlayerPos(i, x, y, z);
	}
	return 1;
}

forward SetServerTimeForAll();
public SetServerTimeForAll()
{
    if(SERVER_SECOND < 60)
	{
	    SERVER_SECOND += 1;
	}
	if(SERVER_SECOND == 60)
	{
	    SERVER_MINUTE += 1;
	    SERVER_SECOND = 00;
	    return 1;
	}
	if(SERVER_MINUTE == 60)
	{
	    SERVER_HOUR += 1;
	    SERVER_MINUTE = 00;
	    SERVER_SECOND = 00;
	    return 1;
	}
	if(SERVER_HOUR == 24)
	{
	    SERVER_SECOND = 00;
	    SERVER_MINUTE = 00;
	    SERVER_HOUR =  00;
	    return 1;
	}

	new string[256];
	format(string, sizeof string, "~w~%s%d:%s%d", (SERVER_HOUR < 10) ? ("0") : (""), SERVER_HOUR, (SERVER_MINUTE < 10) ? ("0") : (""), SERVER_MINUTE);
 	TextDrawSetString(Time, string);

	return 1;
}

forward LSFD_JOB_HOUSE_FIRE();
public LSFD_JOB_HOUSE_FIRE()
{
	if(LSFDJobHouseFire == 0 && LSFDJobHouseFireAccepted == 0)
	{
	    new randomNumber = GetValidHouseJobNumber();
	    
	    LSFDJobHouseFire = 1;
	    LSFDJobHouseFireHealth = 100;
	    LSFDJobHouseFireID = randomNumber;
	    
	    LSFDJobHouseFireObject = CreateObject(18691, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z]-2.61, 0, 0, 0.0);
	    LSFDJobHouseSmokeObject = CreateObject(18715, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 0, 0, 0.0);

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: There is a gas explosion at a property, huge fire has risen! [/acceptjob])");
		SendFactionRadioMessage(2, COLOR_WHITE, dstring);

		print("LSFD Job Fire Created");
	}
	return 1;
}

forward EXP_LSFD_JOB_HOUSE_FIRE();
public EXP_LSFD_JOB_HOUSE_FIRE()
{
	if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 0)
	{
	    LSFDJobHouseFire = 0;
	    LSFDJobHouseFireHealth = 0;
	    LSFDJobHouseFireID = 0;
	    
	    DestroyObject(LSFDJobHouseFireObject);
	    DestroyObject(LSFDJobHouseSmokeObject);
	    
	    LSFDJobHouseFireObject = 0;
	    LSFDJobHouseSmokeObject = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We just had a call that the house has burnt down! LSFD has failed this task)");
		SendFactionRadioMessage(2, COLOR_WHITE, dstring);

		print("LSFD Job Fire Failed 1");
	}
	else if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 1 && LSFDJobHouseFireHealth == 100)
	{
	    LSFDJobHouseFire = 0;
	    LSFDJobHouseFireAccepted = 0;
	    LSFDJobHouseFireHealth = 0;
	    LSFDJobHouseFireID = 0;

	    DestroyObject(LSFDJobHouseFireObject);
	    DestroyObject(LSFDJobHouseSmokeObject);

	    LSFDJobHouseFireObject = 0;
	    LSFDJobHouseSmokeObject = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We just had a call that the house has burnt down! LSFD has failed this task)");
		SendFactionRadioMessage(2, COLOR_WHITE, dstring);

		print("LSFD Job Fire Failed 2");
	}
	else if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 1 && LSFDJobHouseFireHealth > 0 && LSFDJobHouseFireHealth < 100)
	{
	    LSFDJobHouseFire = 0;
	    LSFDJobHouseFireAccepted = 0;
	    LSFDJobHouseFireHealth = 0;
	    LSFDJobHouseFireID = 0;

	    DestroyObject(LSFDJobHouseFireObject);
	    DestroyObject(LSFDJobHouseSmokeObject);
	    
	    LSFDJobHouseFireObject = 0;
	    LSFDJobHouseSmokeObject = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: We just had a call that the house has burnt down! LSFD has failed this task)");
		SendFactionRadioMessage(2, COLOR_WHITE, dstring);

		print("LSFD Job Fire Failed 3");
	}
	else if(LSFDJobHouseFire == 0 && LSFDJobHouseFireAccepted == 0)
	{
	    print("LSFD Job Fire Finished - Timer Restarted");
	}
	return 1;
}

forward LSPD_JOB_HOUSE_INSPECTION();
public LSPD_JOB_HOUSE_INSPECTION()
{
	if(LSPDJobHouseInspection == 0 && LSPDJobHouseInspectionAccepted == 0)
	{
	    LSPDJobHouseInspection = 1;
	    
	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: An by stander has called in a report on illegal activty at a house, please investigate! [/acceptjob 1])");
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);
		
		print("LSPD Job Created");
	}
	return 1;
}

forward EXP_LSPD_JOB_HOUSE_INSPECTION();
public EXP_LSPD_JOB_HOUSE_INSPECTION()
{
	if(LSPDJobHouseInspection == 1 && LSPDJobHouseInspectionAccepted == 0)
	{
	    LSPDJobHouseInspection = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The people have no left the area! LSPD has failed this task)");
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);
		
		print("LSPD Job Failed 1");
	}
	else if(LSPDJobHouseInspection == 1 && LSPDJobHouseInspectionAccepted == 1)
	{
	    LSPDJobHouseInspection = 0;
	    LSPDJobHouseInspectionAccepted = 0;
	    
	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The security company has already arrived on scene and cleared the job! LSPD has failed this task)");
		SendFactionRadioMessage(1, COLOR_WHITE, dstring);
		
		print("LSPD Job Failed 2");
	}
	else if(LSPDJobHouseInspection == 0 && LSPDJobHouseInspectionAccepted == 0)
	{
	    print("LSPD Job Needs Creating");
	}
	return 1;
}

forward DUDEFIX_JOB_PIPE_BLAST();
public DUDEFIX_JOB_PIPE_BLAST()
{
	if(DudefixJob == 0 && DudefixJobAccepted == 0)
	{
	    new randomNumber;
		randomNumber = random(3) + 1;

        DudefixJob = 1;
	    DudefixJobID = randomNumber;
	    
	    if(DudefixJobID == 1)
	    {
	        DudeFixObjectOne = CreateDynamicObject(3865, 1352.17017, -1397.91748, 12.25227,   26.52001, 71.70001, 116.57999);
			DudeFixObjectTwo = CreateDynamicObject(746, 1352.20020, -1395.06470, 12.38176,   0.00000, 0.00000, 0.00000);
			DudeFixObjectThree = CreateDynamicObject(746, 1354.84485, -1398.43799, 12.38176,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFour = CreateDynamicObject(746, 1348.37390, -1399.37317, 10.53745,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFive = CreateDynamicObject(18739, 1348.43408, -1399.46362, 12.73625,   0.00000, 0.00000, 0.00000);
		}
		else if(DudefixJobID == 2)
	    {
            DudeFixObjectOne = CreateDynamicObject(3865, 1527.92517, -1671.25366, 11.39843,   14.40001, 10.56000, -139.56006);
			DudeFixObjectTwo = CreateDynamicObject(746, 1527.42981, -1673.72827, 12.37432,   0.00000, 0.00000, 0.00000);
			DudeFixObjectThree = CreateDynamicObject(746, 1532.23157, -1673.28320, 12.37579,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFour = CreateDynamicObject(746, 1526.41724, -1668.61755, 12.37671,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFive = CreateDynamicObject(18739, 1530.20593, -1674.75037, 12.37378,   0.00000, 0.00000, 0.00000);
		}
		else if(DudefixJobID == 3)
	    {
            DudeFixObjectOne = CreateDynamicObject(3865, 2092.47217, -1751.63062, 14.03432,   46.67999, -10.44001, 0.00000);
			DudeFixObjectTwo = CreateDynamicObject(746, 2090.65234, -1753.89099, 12.38976,   0.00000, 0.00000, 0.00000);
			DudeFixObjectThree = CreateDynamicObject(746, 2091.60034, -1749.64600, 12.39043,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFour = CreateDynamicObject(746, 2094.53247, -1751.27051, 12.39093,   0.00000, 0.00000, 0.00000);
			DudeFixObjectFive = CreateDynamicObject(18739, 2093.98975, -1753.59204, 12.87132,   0.00000, 0.00000, 0.00000);
		}

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: A pipe has burst in the streets of Los Santos, go fix it! [/acceptjob])");
		SendFactionRadioMessage(8, COLOR_WHITE, dstring);

		print("Dudefix Job Created");
	}
	return 1;
}

forward EXP_DUDEFIX_JOB_PIPE_BLAST();
public EXP_DUDEFIX_JOB_PIPE_BLAST()
{
	if(DudefixJob == 1 && DudefixJobAccepted == 0)
	{
	    DudefixJob = 0;
     	DudefixJobID = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Another company has come through and cleaned up the streets! This company has failed this task)");
		SendFactionRadioMessage(8, COLOR_WHITE, dstring);
		
		DestroyDynamicObject(DudeFixObjectOne);
     	DestroyDynamicObject(DudeFixObjectTwo);
     	DestroyDynamicObject(DudeFixObjectThree);
     	DestroyDynamicObject(DudeFixObjectFour);
		DestroyDynamicObject(DudeFixObjectFive);

		print("Dudefix Job Failed 1");
	}
	else if(DudefixJob == 1 && DudefixJobAccepted == 1 && DudefixJobCompleted == 0)
	{
	    DudefixJob = 0;
	    DudefixJobAccepted = 0;
     	DudefixJobCompleted = 0;
     	DudefixJobID = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Another company has come through and cleaned up the streets! This company has failed this task)");
		SendFactionRadioMessage(8, COLOR_WHITE, dstring);
		
		DestroyDynamicObject(DudeFixObjectOne);
     	DestroyDynamicObject(DudeFixObjectTwo);
     	DestroyDynamicObject(DudeFixObjectThree);
     	DestroyDynamicObject(DudeFixObjectFour);
		DestroyDynamicObject(DudeFixObjectFive);

		print("Dudefix Job Failed 2");
	}
	else if(DudefixJob == 0 && DudefixJobAccepted == 0)
	{
	    print("Dudefix Job Needs Creating");
	}
	return 1;
}

forward MECHANIC_JOB_VEHICLE_HEALTH();
public MECHANIC_JOB_VEHICLE_HEALTH()
{
	if(MechanicJob == 0 && MechanicJobAccepted == 0)
	{
	    new randomNumber = GetValidMechanicJobNumber();

	    MechanicJob = 1;
     	MechanicJobHealth = 0;
     	MechanicJobID = randomNumber;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: A vehicle has been called in requiring repairs! [/acceptjob])");
		SendFactionRadioMessage(9, COLOR_WHITE, dstring);

		print("Mechanic Job Created");
	}
	return 1;
}

forward EXP_MECHANIC_JOB_VEHICLE_HEALTH();
public EXP_MECHANIC_JOB_VEHICLE_HEALTH()
{
	if(MechanicJob == 1 && MechanicJobAccepted == 0)
	{
	    MechanicJob = 0;
     	MechanicJobHealth = 0;
     	MechanicJobID = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The vehicle job that came through has been found burnt out! This company has failed this task)");
		SendFactionRadioMessage(9, COLOR_WHITE, dstring);

		print("Mechanic Job Failed 1");
	}
	else if(MechanicJob == 1 && MechanicJobAccepted == 1 && MechanicJobHealth == 0)
	{
	    MechanicJob = 0;
	    MechanicJobAccepted = 0;
     	MechanicJobHealth = 0;
     	MechanicJobID = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The vehicle has been passed onto another company! This company has failed this task)");
		SendFactionRadioMessage(9, COLOR_WHITE, dstring);

		print("Mechanic Job Failed 2");
	}
	else if(MechanicJob == 1 && MechanicJobAccepted == 1 && MechanicJobHealth > 0 && MechanicJobHealth < 100)
	{
	    MechanicJob = 0;
	    MechanicJobAccepted = 0;
     	MechanicJobHealth = 0;
     	MechanicJobID = 0;

	    new dstring[256];
		format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: The vehicle has been passed onto another company! This company has failed this task)");
		SendFactionRadioMessage(9, COLOR_WHITE, dstring);

		print("Mechanic Job Failed 2");
	}
	else if(MechanicJob == 0 && MechanicJobAccepted == 0)
	{
	    print("Mechanic Job Needs Creating");
	}
	return 1;
}

forward ONE_SECOND_TIMER();
public ONE_SECOND_TIMER()
{
	SetServerTimeForAll();

    /* ----- PLAYER MESSAGE DISPLAYS ----- */
	foreach(new i : Player)	
	//for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerLogged[i] == 1)
		{
		    if(PlayerData[i][Character_Registered] == 1)
		    {
		        /* ----- AMMUNATION ROBBERY TIMER ----- */

				if(HasPlayerRobbedAmmunation[i] > 0)
				{
				    HasPlayerRobbedAmmunation[i] --;
				}
	
		        if(IsPlayerInRangeOfPoint(i, 3.0, 1439.5317,-2281.4648,13.5469))
		        {
                    GameTextForPlayer(i, "/ASSISTANCE", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1418.1593,-2311.6946,13.9298))
		        {
                    GameTextForPlayer(i, "/RENTCAR", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 2409.5278,-1426.0397,23.9829))
		        {
                    GameTextForPlayer(i, "/RECYCLECAR", 5000, 5);
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, -1876.2999,50.1774,1055.1891))
		        {
                    GameTextForPlayer(i, "/GUIDE", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1376.2294,-1423.9144,13.5768))
		        {
                    GameTextForPlayer(i, "/GETLICENSE", 5000, 5); // DRIVING SCHOOL
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 2142.8154,1620.1243,1000.9688))
		        {
                    GameTextForPlayer(i, "/RAPPEL", 5000, 5); // BANK ROPE LOCATION
		        }
		        else if(IsPlayerInRangeOfPoint(i, 1.0, 2164.5356,1600.1710,999.9771))
		        {
                    GameTextForPlayer(i, "/BANKACCOUNT", 5000, 5); // BANK LOCATION
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 254.4426,76.9794,1003.6406) || IsPlayerInRangeOfPoint(i, 3.0, -1098.1952,1995.3502,-58.9141) || IsPlayerInRangeOfPoint(i, 3.0, -1098.1952,1995.3502,-58.9141) || IsPlayerInRangeOfPoint(i, 3.0, 1780.0322,-1693.6436,16.7503) || IsPlayerInRangeOfPoint(i, 3.0, 2051.0803,-1842.6533,13.5633) || IsPlayerInRangeOfPoint(i, 3.0, 2051.0803,-1842.6533,13.5633) || IsPlayerInRangeOfPoint(i, 3.0, 618.3365,-76.9667,997.9922))
		        {
		            GameTextForPlayer(i, "/DUTY", 5000, 5); // DUTY LOCATIONS
				}
				else if(IsPlayerInRangeOfPoint(i, 5, 1943.48840, -1984.64282, 13.48357) && HasPlayerEnteredSprayUnit[i] == 0)
		        {
		            GameTextForPlayer(i, "PRESS N", 5000, 3); // SPRAY LOCATIONS
				}
				else if(IsPlayerInRangeOfPoint(i, 3.0, 254.4943,85.0860,1002.4453) && PlayerData[i][Character_Faction] == 1)
		        {
		            GameTextForPlayer(i, "/ARREST", 5000, 5); // ARREST LOCATIONS
				}
				else if(IsPlayerInRangeOfPoint(i, 3.0, 1783.4768,-1694.1383,16.7503) && PlayerData[i][Character_Faction] == 2)
		        {
		            GameTextForPlayer(i, "/FIREEX", 5000, 5); // FIREEX GEAR LSFD
				}
				else if(IsPlayerInRangeOfPoint(i, 3.0, 2054.3008,-1842.2689,13.5633) && PlayerData[i][Character_Faction] == 9)
		        {
		            GameTextForPlayer(i, "/TOOLS", 5000, 5); // TOOLS MECHANIC
				}
				else if(IsPlayerInRangeOfPoint(i, 3.0, 2102.2109, -1789.1084, 13.5547)) // Pizza Delivery Point
		        {
					if(PlayerData[i][Character_Job] != 1)
					{
			            new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Pizza Delivery Job~n~~n~~w~Type ~y~/joinjob~w~ to join this team!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
					else if(PlayerData[i][Character_Job] == 1)
					{
						new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Pizza Delivery Job~n~~n~~w~Type ~y~/startjob~w~ to start delivering pizzas!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
				else if(IsPlayerInRangeOfPoint(i, 3.0, 2201.1582,-1974.1382,13.5576)) // Garbage Job Point
		        {
					if(PlayerData[i][Character_Job] != 2)
					{
			            new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Garbage Collection Job~n~~n~~w~Type ~y~/joinjob~w~ to join this team!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
					else if(PlayerData[i][Character_Job] == 2)
					{
						new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Garbage Collection Job~n~~n~~w~Type ~y~/startjob~w~ to start collecting rubbish!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
				else if(IsPlayerInRangeOfPoint(i, 3.0, 992.1449,-1454.0868,13.5469)) // Electrician Job Point
		        {
					if(PlayerData[i][Character_Job] != 3)
					{
			            new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Electrician Job~n~~n~~w~Type ~y~/joinjob~w~ to join this team!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
					else if(PlayerData[i][Character_Job] == 3)
					{
						new tdstring1[500];
	    				format(tdstring1, sizeof(tdstring1), "~y~Electrician Job~n~~n~~w~Type ~y~/startjob~w~ to start a route!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
	
				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
				else if(IsPlayerInRangeOfPoint(i, 3.0, 1544.5784,-1670.9464,13.5587)) // LSPD JOIN POINT
		        {
		            new tdstring1[500];
    				format(tdstring1, sizeof(tdstring1), "~y~Los Santos Police Department~n~~n~~w~Type ~y~/joinfaction~w~ to apply!");
					PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
					PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

			        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1755.8239,-1720.1548,13.3870)) // LSFD JOIN POINT
		        {
		            new tdstring1[500];
    				format(tdstring1, sizeof(tdstring1), "~y~Los Santos Fire Department~n~~n~~w~Type ~y~/joinfaction~w~ to apply!");
					PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
					PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

			        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1178.3011,-1328.0625,14.1133)) // LSMC JOIN POINT
		        {
		            new tdstring1[500];
    				format(tdstring1, sizeof(tdstring1), "~y~Los Santos Medical Department~n~~n~~w~Type ~y~/joinfaction~w~ to apply!");
					PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
					PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

			        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
		        }
				else if(IsPlayerInRangeOfPoint(i, 3.0, 1498.2710,-1581.8063,13.5498))
		        {
		            if(PlayerData[i][Character_Hotel_ID] == 1)
		            {
		                new tdstring1[500];
					    format(tdstring1, sizeof(tdstring1), "~y~Trump Hotel~n~~n~~w~Tap ~y~Enter_Key~w~ To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
		            }
		            else
		            {
		                new tdstring2[500];
					    format(tdstring2, sizeof(tdstring2), "~y~Trump Hotel~n~~n~~y~$250 ~w~for a room~n~~n~~y~/rent~w~ to purchase a room!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
		            }
				}
				else if(IsPlayerInRangeOfPoint(i, 3.0, 267.2495,304.6546,999.1484))
		        {
		            new tdstring1[500];
    				format(tdstring1, sizeof(tdstring1), "Tap ~y~Enter_Key~w~ To Use Door!");
					PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
					PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

			        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
				}
		        for(new r = 1; r < MAX_DOORS; r++)
		        {
		            if(IsPlayerInRangeOfPoint(i, 1.0, DoorData[r][Door_Outside_X], DoorData[r][Door_Outside_Y], DoorData[r][Door_Outside_Z]))
		            {
		                if(PlayerData[i][Admin_Level] > 4)
		                {
			            	new tdstring1[500];
						    format(tdstring1, sizeof(tdstring1), "(Door ID: %i)~n~%s~n~~n~Tap ~y~Enter_Key~w~ To Use Door!", DoorData[r][Door_ID], DoorData[r][Door_Description]);
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
						else
						{
						    new tdstring2[500];
						    format(tdstring2, sizeof(tdstring2), "%s~n~~n~Tap ~y~Enter_Key~w~ To Use Door!", DoorData[r][Door_Description]);
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
					}
					if(IsPlayerInRangeOfPoint(i, 1.0, DoorData[r][Door_Inside_X], DoorData[r][Door_Inside_Y], DoorData[r][Door_Inside_Z]))
		            {
		                if(PlayerData[i][Admin_Level] > 4)
		                {
			            	new tdstring1[500];
						    format(tdstring1, sizeof(tdstring1), "(Door ID: %i)~n~~n~Tap ~y~Enter_Key~w~ To Use Door!", DoorData[r][Door_ID]);
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
						else
						{
			            	new tdstring2[500];
						    format(tdstring2, sizeof(tdstring2), "Tap ~y~Enter_Key~w~ To Use Door!");
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
					}
		        }
		        for(new e = 1; e < MAX_FACTIONS; e++)
		        {
                    if(FactionData[e][Faction_Icon_X] != 0 && FactionData[e][Faction_Sold] == 0)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, FactionData[e][Faction_Icon_X], FactionData[e][Faction_Icon_Y], FactionData[e][Faction_Icon_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
			                    new tdstring1[500];
							    format(tdstring1, sizeof(tdstring1), "(Faction ID: %i)~n~%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~n~~n~~y~/buyfaction~w~ to buy this faction!", FactionData[e][Faction_ID], FactionData[e][Faction_Name], FactionData[e][Faction_Price_Money], FactionData[e][Faction_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
							    format(tdstring2, sizeof(tdstring2), "%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~n~~n~~y~/buyfaction~w~ to buy this faction!", FactionData[e][Faction_Name], FactionData[e][Faction_Price_Money], FactionData[e][Faction_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
					if(FactionData[e][Faction_Icon_X] != 0 && FactionData[e][Faction_Sold] == 1)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, FactionData[e][Faction_Icon_X], FactionData[e][Faction_Icon_Y], FactionData[e][Faction_Icon_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
			                    new tdstring1[500];
			                    format(tdstring1, sizeof(tdstring1), "(Faction ID: %i)~n~%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s", FactionData[e][Faction_ID], FactionData[e][Faction_Name], FactionData[e][Faction_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
							    format(tdstring2, sizeof(tdstring2), "%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s",FactionData[e][Faction_Name], FactionData[e][Faction_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
				}
		        for(new w = 1; w < MAX_HOUSES; w++)
		        {
                    if(HouseData[w][House_Outside_X] != 0 && HouseData[w][House_Sold] == 0)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[w][House_Outside_X], HouseData[w][House_Outside_Y], HouseData[w][House_Outside_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
			                    new tdstring1[500];
           						format(tdstring1, sizeof(tdstring1), "(House ID: %i)~n~%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~w~~n~~n~(Tap ENTER_KEY to go inside!)~n~~n~~y~/buyproperty~w~ to buy this property!", HouseData[w][House_ID], HouseData[w][House_Address], HouseData[w][House_Price_Money], HouseData[w][House_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
           						format(tdstring2, sizeof(tdstring2), "%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~w~~n~~n~(Tap ENTER_KEY to go inside!)~n~~n~~y~/buyproperty~w~ to buy this property!", HouseData[w][House_Address], HouseData[w][House_Price_Money], HouseData[w][House_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
					if(HouseData[w][House_Outside_X] != 0 && HouseData[w][House_Sold] == 1)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[w][House_Outside_X], HouseData[w][House_Outside_Y], HouseData[w][House_Outside_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
                       			new tdstring1[500];
							    format(tdstring1, sizeof(tdstring1), "(House ID: %i)~n~%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s~n~~n~(Tap ENTER_KEY to go inside!)", HouseData[w][House_ID], HouseData[w][House_Address], HouseData[w][House_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
							    format(tdstring2, sizeof(tdstring2), "%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s~n~~n~(Tap ENTER_KEY to go inside!)", HouseData[w][House_Address], HouseData[w][House_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
					if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[w][House_Inside_X], HouseData[w][House_Inside_Y], HouseData[w][House_Inside_Z]) && HouseData[w][House_Inside_VW] == GetPlayerVirtualWorld(i))
		            {
		            	new tdstring1[500];
					    format(tdstring1, sizeof(tdstring1), "Tap ~y~Enter_Key~w~ To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
		        for(new q = 1; q < MAX_BUSINESSES; q++)
		        {
                    if(BusinessData[q][Business_Outside_X] != 0 && BusinessData[q][Business_Sold] == 0)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, BusinessData[q][Business_Outside_X], BusinessData[q][Business_Outside_Y], BusinessData[q][Business_Outside_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
			                    new tdstring1[500];
							    format(tdstring1, sizeof(tdstring1), "(Business ID: %i)~n~%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~w~~n~~n~(Tap ENTER_KEY to go inside!)~n~~n~~y~/buybusiness~w~ to buy this business!", BusinessData[q][Business_ID], BusinessData[q][Business_Name], BusinessData[q][Business_Price_Money], BusinessData[q][Business_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
							    format(tdstring2, sizeof(tdstring2), "%s~n~~y~Cost: ~w~$%i ~p~(%i Coins)~w~~n~~n~(Tap ENTER_KEY to go inside!)~n~~n~~y~/buybusiness~w~ to buy this business!", BusinessData[q][Business_Name], BusinessData[q][Business_Price_Money], BusinessData[q][Business_Price_Coins]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
					if(BusinessData[q][Business_Outside_X] != 0 && BusinessData[q][Business_Sold] == 1)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, BusinessData[q][Business_Outside_X], BusinessData[q][Business_Outside_Y], BusinessData[q][Business_Outside_Z]))
			            {
			                if(PlayerData[i][Admin_Level] > 4)
			                {
                       			new tdstring1[500];
							    format(tdstring1, sizeof(tdstring1), "(Business ID: %i)~n~%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s~n~~n~(Tap ENTER_KEY to go inside!)", BusinessData[q][Business_ID], BusinessData[q][Business_Name], BusinessData[q][Business_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
			                }
			                else
			                {
				            	new tdstring2[500];
							    format(tdstring2, sizeof(tdstring2), "%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s~n~~n~(Tap ENTER_KEY to go inside!)", BusinessData[q][Business_Name], BusinessData[q][Business_Owner]);
								PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring2);
								PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

						        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
							}
						}
					}
					if(IsPlayerInRangeOfPoint(i, 3.0, BusinessData[q][Business_Inside_X], BusinessData[q][Business_Inside_Y], BusinessData[q][Business_Inside_Z]) && BusinessData[q][Business_Inside_VW] == GetPlayerVirtualWorld(i))
		            {
		            	new tdstring1[500];
					    format(tdstring1, sizeof(tdstring1), "Tap ~y~Enter_Key~w~ To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
          		if(PlayerData[i][Character_Level] >= 0 && PlayerData[i][Character_Level_Exp] == 8)
				{
					new dstring[256];
					
				    PlayerData[i][Character_Level] += 1;
				    PlayerData[i][Character_Level_Exp] = 0;
				    SetPlayerScore(i, PlayerData[i][Character_Level]);
				    
				    format(dstring,sizeof(dstring),"{33CC99}[ACHIEVEMENT]: %s has just leveled up to level %d | Congratulations", GetName(i), PlayerData[i][Character_Level]);
			        SendClientMessageToAll(-1,dstring);
	    		}
	    		
	    		new Float:h;
	    		GetPlayerHealth(i, h);
	    		if(h < 10 && IsPlayerInjured[i] == 0 && HasPlayerFirstSpawned[i] == 1)
	    		{
	    		    IsPlayerInjured[i] = 1;
	    		    ClearAnimations(i);
	    		    ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, false, true, true, true, 0, SYNC_ALL);
	    		    
	    		    new tdstring1[500];
			    	format(tdstring1, sizeof(tdstring1), "You are about to die! Use /acceptdeath, when roleplay has finished!");
					PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring1);
					PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);
					
			        Notification_Timer[i] = SetTimerEx("OnTimerCancels", 10000, false, "i", i);
	    		}
	    		
	    		if(IsPlayerTased[i] == 1)
	    		{
					ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, false, true, true, true, 0, SYNC_ALL);
	    		}

				new v = GetPlayerVehicleID(i);
				if(VehicleData[v][Vehicle_Fuel] <= 1)
				{
				    VehicleData[v][Vehicle_Fuel] = 0;

					new engine, lights, alarm, doors, bonnet, boot, objective;
					new string[256];
					GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);
					
					if(engine == 1)
					{
					    SetVehicleParamsEx(v, false, lights, alarm, doors, bonnet, boot, objective);
					    format(string, sizeof(string), "> %s's vehicle has turned off randomly", GetName(i));
						SendNearbyMessage(i, 30.0, COLOR_PURPLE, string);

                        PlayerTextDrawSetString(i, SpeedBoxFuelAmount, "-");
                        
						KillTimer(Fuel_Timer[i]);
						KillTimer(Vehicle_Timer[i]);
						
						Fuel_Timer[i] = 0;
						Vehicle_Timer[i] = 0;
					}
				}
			}
		}
	}
	
	/* ----- VEHICLE DEATH SYSTEM ----- */
	for(new v; v<MAX_VEHICLES; v++)
	{
		new Float:vehiclehealth;
		GetVehicleHealth(v, vehiclehealth);
		
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);

		if(engine == 1 && vehiclehealth < 300.0)
		{
			SetVehicleParamsEx(v, false, lights, alarm, doors, bonnet, boot, objective);
			
			SetVehicleHealth(v, 300.0);

			printf("a vehicle has just turned off due to high damage");
		}
	}

	/* ----- BANK ROBBERY TIMER ----- */
	if(BankRobberyTimer > 0 && BankRobberyTimer < 60 && BankRobberyTimerExp == 0)
	{
	    BankRobberyTimer += 1;
	}
	else if(BankRobberyTimer == 60 && BankRobberyTimerExp == 0)
	{
        BankRobberyTimerExp += 1;
        
        for(new i; i<MAX_PLAYERS; i++)
		{
		    if(HasPlayerBrokenIntoBank[i] == 1 && HasPlayerRobbedBank[i] == 1)
		    {
			    new string[256];

			    if(BankDoorOpen == false)
				{
				    MoveDynamicObject(BankDoor, 2145.1274, 1626.2031, 994.2476, 0.05, 0.00000, 0.00000, 270.00000);
		          	BankDoorOpen = true;

		           	format(string, sizeof(string), "> Bank door slowly opens due to security features in play");
					SendNearbyMessage(i, 30.0, COLOR_PURPLE, string);
				}

				new amountrobbed;
				amountrobbed = 1 + random(50000);

				PlayerData[i][Character_Money] += amountrobbed;

				format(string, sizeof(string), "> %s has successfully stolen money from the bank", GetName(i));
				SendNearbyMessage(i, 30.0, COLOR_PURPLE, string);

				format(string, sizeof(string), "- You have just stolen $%d.00 worth of money from the vault, get out of there before the cops show up!", amountrobbed);
				SendClientMessage(i, COLOR_YELLOW, string);

				HasPlayerBrokenIntoBank[i] = 0;
				HasPlayerRobbedBank[i] = 0;

				TogglePlayerControllable(i, true);

				printf("Bank Robbery - Player Has Successfully Robbed The Bank");
			}
		}
	}
	else if(BankRobberyTimer == 60 && BankRobberyTimerExp < 600)
	{
        BankRobberyTimerExp += 1;
	}
	else if(BankRobberyTimer == 60 && BankRobberyTimerExp == 600)
	{
	    BankRobberyTimer = 0;
	    BankRobberyTimerExp = 0;
	    
	    printf("Bank Robbery Timer Reset");
	}
	
	/* ----- TORNADO TIMER ----- */
	if(TornadoTimer < 600)
	{
	    TornadoTimer += 1;
	}
	else if(TornadoTimer == 600)
	{
	    DestroyObject(TornadoObject1);
     	DestroyObject(TornadoObject2);
     	DestroyObject(TornadoObject3);
     	DestroyObject(TornadoObject4);
		DestroyObject(TornadoObject5);
		DestroyObject(TornadoObject6);
	    
	    TornadoTimer = 0;
	}
	
	/* ----- LSPD JOB TIMER ----- */
	if(LSPDJobTimer < 600 && LSPDJobTimerExp == 0)
	{
	    LSPDJobTimer += 1;
	}
	else if(LSPDJobTimer == 600 && LSPDJobTimerExp < 450)
	{
	    LSPD_JOB_HOUSE_INSPECTION();
	    
	    LSPDJobTimerExp += 1;
	}
	else if(LSPDJobTimer == 600 && LSPDJobTimerExp == 450)
	{
	    EXP_LSPD_JOB_HOUSE_INSPECTION();

	    LSPDJobTimer = 0;
	    LSPDJobTimerExp = 0;
	}
	
	/* ----- LSFD JOB TIMER ----- */
	if(LSFDJobTimer < 600 && LSFDJobTimerExp == 0)
	{
	    LSFDJobTimer += 1;
	}
	else if(LSFDJobTimer == 600 && LSFDJobTimerExp < 450)
	{
	    LSFD_JOB_HOUSE_FIRE();

	    LSFDJobTimerExp += 1;
	}
	else if(LSFDJobTimer == 600 && LSFDJobTimerExp == 450)
	{
	    EXP_LSFD_JOB_HOUSE_FIRE();

	    LSFDJobTimer = 0;
	    LSFDJobTimerExp = 0;
	}
	
	/* ----- DUDEFIX JOB TIMER ----- */
	if(DudefixJobTimer <= 849 && DudefixJobTimerExp == 0)
	{
	    DudefixJobTimer += 1;
	}
	else if(DudefixJobTimer == 850 && DudefixJobTimerExp <= 449)
	{
	    DUDEFIX_JOB_PIPE_BLAST();
	    
	    DudefixJobTimerExp += 1;
	}
	else if(DudefixJobTimer == 850 && DudefixJobTimerExp == 450)
	{
	    EXP_DUDEFIX_JOB_PIPE_BLAST();

	    DudefixJobTimer = 0;
	    DudefixJobTimerExp = 0;
	}
	
	/* ----- MECHANIC JOB TIMER ----- */
	if(MechanicJobTimer < 600 && MechanicJobTimerExp == 0)
	{
	    MechanicJobTimer += 1;
	}
	else if(MechanicJobTimer == 600 && MechanicJobTimerExp < 450)
	{
	    MECHANIC_JOB_VEHICLE_HEALTH();

	    MechanicJobTimerExp += 1;
	}
	else if(MechanicJobTimer == 600 && MechanicJobTimerExp == 450)
	{
	    EXP_MECHANIC_JOB_VEHICLE_HEALTH();

	    MechanicJobTimer = 0;
	    MechanicJobTimerExp = 0;
	}
	
	/* ----- DRUG TIMER ----- */
	if(DrugTimer < 3600)
	{
	    DrugTimer += 1;
	}
	else if(DrugTimer == 3600)
	{
		if(DrugActor != 0)
		{
			new randIndex = random(sizeof(DrugDealerActorLocations));
			
			DestroyActor(DrugActor);
			DrugActor = CreateActor(29, DrugDealerActorLocations[randIndex][0],DrugDealerActorLocations[randIndex][1],DrugDealerActorLocations[randIndex][2],DrugDealerActorLocations[randIndex][3]);
		    DrugTimer = 0;
			
			printf("New Drug Actor Created");
		}
		else
		{
			new randIndex = random(sizeof(DrugDealerActorLocations));
			
			DrugActor = CreateActor(29, DrugDealerActorLocations[randIndex][0],DrugDealerActorLocations[randIndex][1],DrugDealerActorLocations[randIndex][2],DrugDealerActorLocations[randIndex][3]);
		    DrugTimer = 0;
			printf("New Drug Actor Created");
		}	
	}
	
	/* ----- RANDOM MESSAGE DISLAYS ----- */
	if(SERVER_MESSAGE_COUNT == 0)
	{
		SERVER_MESSAGE_COUNT = 340;
		
		new index = random(sizeof(RandomMessages));
		SendClientMessageToAll(COLOR_CORAL, RandomMessages[index]);	
	}
	else if(SERVER_MESSAGE_COUNT > 0)
	{
		SERVER_MESSAGE_COUNT -= 1;
	}
	
	return 1;
}

forward OnTimerCancels(playerid);
public OnTimerCancels(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		PlayerTextDrawHide(playerid, PlayerText:Notification_Textdraw);
	}
	return 1;
}

forward BackupCheck(playerid);
public BackupCheck(playerid)
{
    if(LSPDBackupPosition[0] != 0)
    {
    	for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(PlayerData[i][Character_Faction] == 1)
		    {
				new playername[50];
			    GetPlayerName(i, playername, MAX_PLAYER_NAME);

	      		if(strcmp(BackupCaller, playername) == 0 && IsPlayerInRangeOfPoint(i, 5.0, LSPDBackupPosition[0], LSPDBackupPosition[1], LSPDBackupPosition[2]))
			    {
	          		return 1;
			    }
			    else if(strcmp(BackupCaller, playername) != 0  && IsPlayerInRangeOfPoint(i, 5.0, LSPDBackupPosition[0],LSPDBackupPosition[1],LSPDBackupPosition[2]))
			    {
			        DisablePlayerCheckpoint(i);

			        LSPDBackupPosition[0] = 0;
			        LSPDBackupPosition[1] = 0;
			        LSPDBackupPosition[2] = 0;
			        
			        BackupCaller = "";
			        
			        KillTimer(Backup_Timer[i]);
			        
			        new dstring[256];
		   			format(dstring, sizeof(dstring), "([BACKUP ALERT - UPDATE] %s has arrived at the backup location)", GetName(i));
					SendFactionRadioMessage(1, COLOR_YELLOW, dstring);
			    }
			    else
			    {
					DisablePlayerCheckpoint(i);
					
					new Float:px, Float:py, Float:pz;
					GetPlayerPos(playerid, px, py, pz);

				    LSPDBackupPosition[0] = px;
				    LSPDBackupPosition[1] = py;
				    LSPDBackupPosition[2] = pz;

					SetPlayerCheckpoint(i, LSPDBackupPosition[0], LSPDBackupPosition[1], LSPDBackupPosition[2], 3.0);
				}
			}
		}
	}
	return 1;
}

forward TaserCancels(playerid);
public TaserCancels(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerTased[playerid] == 1)
		{
		    IsPlayerTased[playerid] = 0;
		    
			PlayerTextDrawHide(playerid, PlayerText:Notification_Textdraw);
			ClearAnimations(playerid);
		}
	}
	return 1;
}

forward LoadFactions();
public LoadFactions()
{
	new sloaded = 1;
    while(sloaded <= MAX_FACTIONS)
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `faction_information` WHERE `faction_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadFaction_Results");

    	sloaded++;
	}
	return 1;
}

forward LoadFaction_Results();
public LoadFaction_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded; 
	
		cache_get_value_name_int(0, "faction_id", loaded);
		cache_get_value_name_int(0, "faction_id", FactionData[loaded][Faction_ID]);
		cache_get_value_name(0, "faction_name", FactionData[loaded][Faction_Name], 20);
		
		cache_get_value_name(0, "faction_rank_1", FactionData[loaded][Faction_Rank_1], 20);
		cache_get_value_name(0, "faction_rank_2", FactionData[loaded][Faction_Rank_2], 20);
		cache_get_value_name(0, "faction_rank_3", FactionData[loaded][Faction_Rank_3], 20);
		cache_get_value_name(0, "faction_rank_4", FactionData[loaded][Faction_Rank_4], 20);
		cache_get_value_name(0, "faction_rank_5", FactionData[loaded][Faction_Rank_5], 20);
		cache_get_value_name(0, "faction_rank_6", FactionData[loaded][Faction_Rank_6], 20);
	
		cache_get_value_name_int(0, "faction_join_requests", FactionData[loaded][Faction_Join_Requests]);

		cache_get_value_name_float(0, "faction_icon_x", FactionData[loaded][Faction_Icon_X]);
		cache_get_value_name_float(0, "faction_icon_y", FactionData[loaded][Faction_Icon_Y]);
		cache_get_value_name_float(0, "faction_icon_z", FactionData[loaded][Faction_Icon_Z]);
		
		cache_get_value_name(0, "faction_owner", FactionData[loaded][Faction_Owner], 50);
        
		cache_get_value_name_int(0, "faction_price_money", FactionData[loaded][Faction_Price_Money]);
		cache_get_value_name_int(0, "faction_price_coins", FactionData[loaded][Faction_Price_Coins]);
		cache_get_value_name_int(0, "faction_sold", FactionData[loaded][Faction_Sold]);
		cache_get_value_name_int(0, "faction_money", FactionData[loaded][Faction_Money]);
        
        FactionData[loaded][Faction_Pickup_ID_Outside] = CreateDynamicPickup(1239, 1,FactionData[loaded][Faction_Icon_X], FactionData[loaded][Faction_Icon_Y], FactionData[loaded][Faction_Icon_Z], -1);
	}
	return 1;
}

forward GetNextFactionValue(playerid);
public GetNextFactionValue(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "faction_id", SQL_FACTION_NEXTID);

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The next avaliable faction id is: %i and it hasn't been set up yet", SQL_FACTION_NEXTID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_FACTION_NEXTID = 0;
    }
    return 1;
}

forward LoadDoors();
public LoadDoors()
{
	new sloaded = 1;
    while(sloaded <= MAX_DOORS)
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `door_information` WHERE `door_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadDoors_Results");

    	sloaded++;
	}
	printf("Server: Doors loaded into the server");
	return 1;
}

forward LoadDoors_Results();
public LoadDoors_Results()
{
    new rows = cache_num_rows();
	
	if(rows)
	{
	    new loaded;
		cache_get_value_name_int(0, "door_id", loaded);
	    
		cache_get_value_name_int(0, "door_id", DoorData[loaded][Door_ID]);
		cache_get_value_name_int(0, "door_faction", DoorData[loaded][Door_Faction]);
		cache_get_value_name(0, "door_description", DoorData[loaded][Door_Description], 50);
		
		cache_get_value_name_float(0, "door_outside_x", DoorData[loaded][Door_Outside_X]);
		cache_get_value_name_float(0, "door_outside_y", DoorData[loaded][Door_Outside_Y]);
		cache_get_value_name_float(0, "door_outside_z", DoorData[loaded][Door_Outside_Z]);
		cache_get_value_name_float(0, "door_outside_a", DoorData[loaded][Door_Outside_A]);
		cache_get_value_name_int(0, "door_outside_interior", DoorData[loaded][Door_Outside_Interior]);
		cache_get_value_name_int(0, "door_outside_vw", DoorData[loaded][Door_Outside_VW]);

		cache_get_value_name_float(0, "door_inside_x", DoorData[loaded][Door_Inside_X]);
		cache_get_value_name_float(0, "door_inside_y", DoorData[loaded][Door_Inside_Y]);
		cache_get_value_name_float(0, "door_inside_z", DoorData[loaded][Door_Inside_Z]);
		cache_get_value_name_float(0, "door_inside_a", DoorData[loaded][Door_Inside_A]);
		cache_get_value_name_int(0, "door_inside_interior", DoorData[loaded][Door_Inside_Interior]);
		cache_get_value_name_int(0, "door_inside_vw", DoorData[loaded][Door_Inside_VW]);

        if(DoorData[loaded][Door_Outside_X] != 0)
      	{
     	    DoorData[loaded][Door_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,DoorData[loaded][Door_Outside_X], DoorData[loaded][Door_Outside_Y], DoorData[loaded][Door_Outside_Z]+0.3, -1);
		}
		if(DoorData[loaded][Door_Inside_X] != 0)
		{
		    DoorData[loaded][Door_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,DoorData[loaded][Door_Inside_X], DoorData[loaded][Door_Inside_Y], DoorData[loaded][Door_Inside_Z]+0.3, -1);
		}
	}
	return 1;
}

forward GetNextDoorValue(playerid);
public GetNextDoorValue(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "door_id", SQL_DOOR_NEXTID);

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The next avaliable door id is: %i and it hasn't been set up yet", SQL_DOOR_NEXTID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_DOOR_NEXTID = 0;
    }
    return 1;
}

forward IsPlayerNearDynamicDoor(playerid);
public IsPlayerNearDynamicDoor(playerid)
{
    for(new a = 1; a < MAX_DOORS; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, DoorData[a][Door_Outside_X], DoorData[a][Door_Outside_Y], DoorData[a][Door_Outside_Z]))
		{
			PlayerAtDoorID[playerid] = a;
			break;
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 3.0, DoorData[a][Door_Inside_X], DoorData[a][Door_Inside_Y], DoorData[a][Door_Inside_Z]))
		{
			PlayerAtDoorID[playerid] = a;
			break;
		}
	}
	return 1;
}

forward LoadHouses();
public LoadHouses()
{
	new sloaded = 1;
    while(sloaded <= MAX_HOUSES)
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `house_information` WHERE `house_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadHouses_Results");

    	sloaded++;
	}
	printf("Server: Houses loaded into the server");
	return 1;
}

forward LoadHouses_Results();
public LoadHouses_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded;
		cache_get_value_name_int(0, "house_id", loaded);

		cache_get_value_name_int(0, "house_id", HouseData[loaded][House_ID]);
		cache_get_value_name_int(0, "house_price_money", HouseData[loaded][House_Price_Money]);
		cache_get_value_name_int(0, "house_price_coins", HouseData[loaded][House_Price_Coins]);
		cache_get_value_name_int(0, "house_sold", HouseData[loaded][House_Sold]);
		
		cache_get_value_name(0, "house_owner", HouseData[loaded][House_Owner], 50);
		cache_get_value_name(0, "house_address", HouseData[loaded][House_Address], 150);
		
		cache_get_value_name_int(0, "house_alarm", HouseData[loaded][House_Alarm]);
		cache_get_value_name_int(0, "house_lock", HouseData[loaded][House_Lock]);
		
		cache_get_value_name_int(0, "house_robbed", HouseData[loaded][House_Robbed]);
		cache_get_value_name_int(0, "house_robbed_value", HouseData[loaded][House_Robbed_Value]);
		
		cache_get_value_name_float(0, "house_spawn_x", HouseData[loaded][House_Spawn_X]);
		cache_get_value_name_float(0, "house_spawn_y", HouseData[loaded][House_Spawn_Y]);
		cache_get_value_name_float(0, "house_spawn_z", HouseData[loaded][House_Spawn_Z]);
		cache_get_value_name_int(0, "house_spawn_interior", HouseData[loaded][House_Spawn_Interior]);
		cache_get_value_name_int(0, "house_spawn_vw", HouseData[loaded][House_Spawn_VW]);

		cache_get_value_name_float(0, "house_outside_x", HouseData[loaded][House_Outside_X]);
		cache_get_value_name_float(0, "house_outside_y", HouseData[loaded][House_Outside_Y]);
		cache_get_value_name_float(0, "house_outside_z", HouseData[loaded][House_Outside_Z]);
		cache_get_value_name_float(0, "house_outside_a", HouseData[loaded][House_Outside_A]);
		cache_get_value_name_int(0, "house_outside_interior", HouseData[loaded][House_Outside_Interior]);
		cache_get_value_name_int(0, "house_outside_vw", HouseData[loaded][House_Outside_VW]);
		
		cache_get_value_name_int(0, "house_preset_type", HouseData[loaded][House_Preset_Type]);
		cache_get_value_name_int(0, "house_alarm_active", HouseData[loaded][House_Alarm_Active]);
		cache_get_value_name_int(0, "house_lock_active", HouseData[loaded][House_Lock_Active]);
		
		cache_get_value_name_float(0, "house_inside_x", HouseData[loaded][House_Inside_X]);
		cache_get_value_name_float(0, "house_inside_y", HouseData[loaded][House_Inside_Y]);
		cache_get_value_name_float(0, "house_inside_z", HouseData[loaded][House_Inside_Z]);
		cache_get_value_name_float(0, "house_inside_a", HouseData[loaded][House_Inside_A]);
		cache_get_value_name_int(0, "house_inside_interior", HouseData[loaded][House_Inside_Interior]);
		cache_get_value_name_int(0, "house_inside_vw", HouseData[loaded][House_Inside_VW]);
		
        if(HouseData[loaded][House_Outside_X] != 0 && HouseData[loaded][House_Sold] == 0)
      	{
     	    HouseData[loaded][House_Pickup_ID_Outside] = CreateDynamicPickup(1273, 1,HouseData[loaded][House_Outside_X], HouseData[loaded][House_Outside_Y], HouseData[loaded][House_Outside_Z], -1);
		}
        if(HouseData[loaded][House_Outside_X] != 0 && HouseData[loaded][House_Sold] == 1)
      	{
     	    HouseData[loaded][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[loaded][House_Outside_X], HouseData[loaded][House_Outside_Y], HouseData[loaded][House_Outside_Z], -1);
		}
		if(HouseData[loaded][House_Inside_X] != 0)
		{
		    HouseData[loaded][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[loaded][House_Inside_X], HouseData[loaded][House_Inside_Y], HouseData[loaded][House_Inside_Z]+0.3, loaded);
		}
	}
	return 1;
}

forward GetPlayerHouseID(playerid);
public GetPlayerHouseID(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "house_id", FoundPlayerHouseID[playerid]);
    }
    return 1;
}

forward GetNextHouseValue(playerid);
public GetNextHouseValue(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "house_id", SQL_HOUSE_NEXTID);

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The next avaliable house id is: %i and it hasn't been set up yet", SQL_HOUSE_NEXTID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_HOUSE_NEXTID = 0;
    }
    return 1;
}

forward IsPlayerNearFactionIcon(playerid);
public IsPlayerNearFactionIcon(playerid)
{
    for(new a = 1; a < MAX_FACTIONS; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, FactionData[a][Faction_Icon_X], FactionData[a][Faction_Icon_Y], FactionData[a][Faction_Icon_Z]))
		{
			PlayerAtFactionID[playerid] = a;
			break;
		}
	}
	return 1;
}

forward IsPlayerNearHouseDoor(playerid);
public IsPlayerNearHouseDoor(playerid)
{
	new vwid;
	vwid = GetPlayerVirtualWorld(playerid);
	
    for(new a = 1; a < MAX_HOUSES; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseData[a][House_Outside_X], HouseData[a][House_Outside_Y], HouseData[a][House_Outside_Z]))
		{
			PlayerAtHouseID[playerid] = a;
			break;
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseData[a][House_Inside_X], HouseData[a][House_Inside_Y], HouseData[a][House_Inside_Z]) && HouseData[a][House_Inside_VW] == vwid)
		{
			PlayerAtHouseID[playerid] = a;
			break;
		}
	}
	return 1;
}

forward LoadBusinesses();
public LoadBusinesses()
{
	new sloaded = 1;
    while(sloaded <= MAX_BUSINESSES)
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `business_information` WHERE `business_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadBusinesses_Results");

    	sloaded++;
	}
	printf("Server: Businesses loaded into the server");
	return 1;
}

forward LoadBusinesses_Results();
public LoadBusinesses_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded;
	
		cache_get_value_name_int(0, "business_id", loaded);

		cache_get_value_name_int(0, "business_id", BusinessData[loaded][Business_ID]);
		cache_get_value_name_int(0, "business_price_money", BusinessData[loaded][Business_Price_Money]);
		cache_get_value_name_int(0, "business_price_coins", BusinessData[loaded][Business_Price_Coins]);
		cache_get_value_name_int(0, "business_sold", BusinessData[loaded][Business_Sold]);
		
		cache_get_value_name(0, "business_owner", BusinessData[loaded][Business_Owner], 50);
		cache_get_value_name(0, "business_name", BusinessData[loaded][Business_Name], 50);

		cache_get_value_name_int(0, "business_type", BusinessData[loaded][Business_Type]);
		cache_get_value_name_int(0, "business_alarm", BusinessData[loaded][Business_Alarm]);
		
		cache_get_value_name_int(0, "business_robbed", BusinessData[loaded][Business_Robbed]);
		cache_get_value_name_int(0, "business_robbed_value", BusinessData[loaded][Business_Robbed_Value]);
		
		cache_get_value_name_float(0, "business_outside_x", BusinessData[loaded][Business_Outside_X]);
		cache_get_value_name_float(0, "business_outside_y", BusinessData[loaded][Business_Outside_Y]);
		cache_get_value_name_float(0, "business_outside_z", BusinessData[loaded][Business_Outside_Z]);
		cache_get_value_name_float(0, "business_outside_a", BusinessData[loaded][Business_Outside_A]);
		cache_get_value_name_int(0, "business_outside_interior", BusinessData[loaded][Business_Outside_Interior]);
		cache_get_value_name_int(0, "business_outside_vw", BusinessData[loaded][Business_Outside_VW]);
		
		cache_get_value_name_float(0, "business_inside_x", BusinessData[loaded][Business_Inside_X]);
		cache_get_value_name_float(0, "business_inside_y", BusinessData[loaded][Business_Inside_Y]);
		cache_get_value_name_float(0, "business_inside_z", BusinessData[loaded][Business_Inside_Z]);
		cache_get_value_name_float(0, "business_inside_a", BusinessData[loaded][Business_Inside_A]);
		cache_get_value_name_int(0, "business_inside_interior", BusinessData[loaded][Business_Inside_Interior]);
		cache_get_value_name_int(0, "business_inside_vw", BusinessData[loaded][Business_Inside_VW]);
		
		cache_get_value_name_float(0, "business_buypoint_x", BusinessData[loaded][Business_BuyPoint_X]);
		cache_get_value_name_float(0, "business_buypoint_y", BusinessData[loaded][Business_BuyPoint_Y]);
		cache_get_value_name_float(0, "business_buypoint_z", BusinessData[loaded][Business_BuyPoint_Z]);

        if(BusinessData[loaded][Business_Outside_X] != 0 && BusinessData[loaded][Business_Sold] == 0)
      	{
     	    BusinessData[loaded][Business_Pickup_ID_Outside] = CreateDynamicPickup(19523, 1,BusinessData[loaded][Business_Outside_X], BusinessData[loaded][Business_Outside_Y], BusinessData[loaded][Business_Outside_Z], -1);
		}
        if(BusinessData[loaded][Business_Outside_X] != 0 && BusinessData[loaded][Business_Sold] == 1)
      	{
     	    BusinessData[loaded][Business_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,BusinessData[loaded][Business_Outside_X], BusinessData[loaded][Business_Outside_Y], BusinessData[loaded][Business_Outside_Z]+0.5, -1);
		}
		if(BusinessData[loaded][Business_Inside_X] != 0)
		{
		    BusinessData[loaded][Business_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,BusinessData[loaded][Business_Inside_X], BusinessData[loaded][Business_Inside_Y], BusinessData[loaded][Business_Inside_Z]+0.5, loaded);
		    CreateDynamicPickup(1274, 1,BusinessData[loaded][Business_BuyPoint_X], BusinessData[loaded][Business_BuyPoint_Y], BusinessData[loaded][Business_BuyPoint_Z], loaded);
		}
	}
	return 1;
}

forward GotoBusinessID(playerid);
public GotoBusinessID(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "business_id", SQL_BUSINESS_ID);
		
		new Float:SQL_BUSINESS_INSIDE_X, Float:SQL_BUSINESS_INSIDE_Y, Float:SQL_BUSINESS_INSIDE_Z;
		cache_get_value_name_float(0, "business_inside_x", SQL_BUSINESS_INSIDE_X);
		cache_get_value_name_float(0, "business_inside_y", SQL_BUSINESS_INSIDE_Y);
		cache_get_value_name_float(0, "business_inside_z", SQL_BUSINESS_INSIDE_Z);

		SetPlayerPos(playerid, SQL_BUSINESS_INSIDE_X, SQL_BUSINESS_INSIDE_Y, SQL_BUSINESS_INSIDE_Z);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have been teleported to business ID: %i", SQL_BUSINESS_ID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_BUSINESS_ID = 0;
		SQL_BUSINESS_INSIDE_X = 0;
		SQL_BUSINESS_INSIDE_X = 0;
		SQL_BUSINESS_INSIDE_X = 0;
    }
    return 1;
}

forward GetNextBusinessID(playerid);
public GetNextBusinessID(playerid)
{
    if(cache_num_rows() > 0)
    {
		cache_get_value_name_int(0, "business_id", SQL_BUSINESS_ID);

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The next avaliable business id is: %i and it hasn't been set up yet", SQL_BUSINESS_NEXTID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_BUSINESS_NEXTID = 0;
    }
    return 1;
}

forward IsPlayerNearBusinessDoor(playerid);
public IsPlayerNearBusinessDoor(playerid)
{
	new vwid;
	vwid = GetPlayerVirtualWorld(playerid);

    for(new a = 1; a < MAX_BUSINESSES; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessData[a][Business_Outside_X], BusinessData[a][Business_Outside_Y], BusinessData[a][Business_Outside_Z]))
		{
			PlayerAtBusinessID[playerid] = a;
			break;
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessData[a][Business_Inside_X], BusinessData[a][Business_Inside_Y], BusinessData[a][Business_Inside_Z]) && BusinessData[a][Business_Inside_VW] == vwid)
		{
			PlayerAtBusinessID[playerid] = a;
			break;
		}
	}
	return 1;
}

forward IsPlayerNearBusinessShopPoint(playerid);
public IsPlayerNearBusinessShopPoint(playerid)
{
    for(new a = 1; a < MAX_BUSINESSES; a++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessData[a][Business_BuyPoint_X], BusinessData[a][Business_BuyPoint_Y], BusinessData[a][Business_BuyPoint_Z]) && BusinessData[a][Business_Inside_VW] == GetPlayerVirtualWorld(playerid))
		{
			PlayerAtBusinessBuyPointID[playerid] = a;
			break;
		}
	}
	return 1;
}

forward LoadVehicles();
public LoadVehicles()
{
	new sloaded = 1;
    while(sloaded <= MAX_VEHICLES)
	{
	    new query[256];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadVehicles_Results");

    	sloaded++;
	}
	printf("Server: Vehicles loaded into the server");
	return 1;
}

forward LoadVehicles_Results();
public LoadVehicles_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded;
		cache_get_value_name_int(0, "vehicle_id", loaded);

		cache_get_value_name_int(0, "vehicle_id", VehicleData[loaded][Vehicle_ID]);
		cache_get_value_name_int(0, "vehicle_faction", VehicleData[loaded][Vehicle_Faction]);
		cache_get_value_name_int(0, "vehicle_job", VehicleData[loaded][Vehicle_Job]);
		cache_get_value_name(0, "vehicle_owner", VehicleData[loaded][Vehicle_Owner], 50);
		cache_get_value_name_int(0, "vehicle_used", VehicleData[loaded][Vehicle_Used]);
		
		cache_get_value_name_int(0, "vehicle_model", VehicleData[loaded][Vehicle_Model]);
		cache_get_value_name_int(0, "vehicle_color_1", VehicleData[loaded][Vehicle_Color_1]);
		cache_get_value_name_int(0, "vehicle_color_2", VehicleData[loaded][Vehicle_Color_2]);
		
		cache_get_value_name_float(0, "vehicle_spawn_x", VehicleData[loaded][Vehicle_Spawn_X]);
		cache_get_value_name_float(0, "vehicle_spawn_y", VehicleData[loaded][Vehicle_Spawn_Y]);
		cache_get_value_name_float(0, "vehicle_spawn_z", VehicleData[loaded][Vehicle_Spawn_Z]);
		cache_get_value_name_float(0, "vehicle_spawn_a", VehicleData[loaded][Vehicle_Spawn_A]);		
		cache_get_value_name_int(0, "vehicle_spawn_interior", VehicleData[loaded][Vehicle_Spawn_Interior]);
		cache_get_value_name_int(0, "vehicle_spawn_vw", VehicleData[loaded][Vehicle_Spawn_VW]);
		
		cache_get_value_name_int(0, "vehicle_lock", VehicleData[loaded][Vehicle_Lock]);
		cache_get_value_name_int(0, "vehicle_alarm", VehicleData[loaded][Vehicle_Alarm]);
		cache_get_value_name_int(0, "vehicle_gps", VehicleData[loaded][Vehicle_GPS]);
		cache_get_value_name_int(0, "vehicle_fuel", VehicleData[loaded][Vehicle_Fuel]);
		cache_get_value_name_int(0, "vehicle_type", VehicleData[loaded][Vehicle_Type]);
		
		cache_get_value_name(0, "vehicle_license_plate", VehicleData[loaded][Vehicle_License_Plate], 50);

        if(VehicleData[loaded][Vehicle_Used] == 0)
        {
            new vehicleid = AddStaticVehicleEx(402, 4572.7007, -1116.7518, 0.3459, 180, 1, 1, -1);

			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[loaded][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
        }
        else if(VehicleData[loaded][Vehicle_Used] != 0 && VehicleData[loaded][Vehicle_Type] != 2)
        {
            new vehicleid = AddStaticVehicleEx(VehicleData[loaded][Vehicle_Model], VehicleData[loaded][Vehicle_Spawn_X], VehicleData[loaded][Vehicle_Spawn_Y], VehicleData[loaded][Vehicle_Spawn_Z], VehicleData[loaded][Vehicle_Spawn_A], VehicleData[loaded][Vehicle_Color_1], VehicleData[loaded][Vehicle_Color_2], -1);

			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[loaded][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
        }
        else if(VehicleData[loaded][Vehicle_Used] != 0 && VehicleData[loaded][Vehicle_Type] == 2)
        {
            new vehicleid = AddStaticVehicleEx(VehicleData[loaded][Vehicle_Model], VehicleData[loaded][Vehicle_Spawn_X], VehicleData[loaded][Vehicle_Spawn_Y], VehicleData[loaded][Vehicle_Spawn_Z], VehicleData[loaded][Vehicle_Spawn_A], VehicleData[loaded][Vehicle_Color_1], VehicleData[loaded][Vehicle_Color_2], 200);

			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[loaded][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
        }

		VehicleData[loaded][Vehicle_Fuel] = 100;
	}
	return 1;
}

forward DealershipFindNextFreeVehicleID(playerid);
public DealershipFindNextFreeVehicleID(playerid)
{
	printf("DealershipFindNextFreeVehicleID - Started");
	
    new rows = cache_num_rows();
    new nextID = 0;

    if (rows > 0)
    {
		cache_get_value_name_int(0, "vehicle_id", nextID);
		
		printf("DealershipFindNextFreeVehicleID - Found an ID");

        HasPlayerConfirmedVehicleID[playerid] = nextID;
        
        IsNewVehicleType[playerid] = 1;

		if(HasPlayerConfirmedVehicleID[playerid] == 0)
		{
			printf("DealershipFindNextFreeVehicleID - Find Another ID Loop");
			
		    new query[128];
		    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
		    mysql_tquery(connection, query, "DealershipFindNextFreeVehicleID", "i", playerid);
		}
		else if(HasPlayerConfirmedVehicleID[playerid] > 0)
		{
			printf("DealershipFindNextFreeVehicleID - Player has found unused ID - Function Passed");
			
			if(IsNewVehicleType[playerid] == 1)
			{
				printf("DealershipFindNextFreeVehicleID - Unused ID - Vehicle Destroyed");
				
				DestroyVehicle(HasPlayerConfirmedVehicleID[playerid]);
						
				printf("DealershipFindNextFreeVehicleID - Unused ID - Vehicle Created");
					    
			    new vehicleid;
				
				if(DealershipType[playerid] == 1)
				{
					new randIndex = random(sizeof(DealershipOneParks));
					vehicleid = AddStaticVehicleEx(VehicleModelPurchasing[playerid], DealershipOneParks[randIndex][0], DealershipOneParks[randIndex][1], DealershipOneParks[randIndex][2], DealershipOneParks[randIndex][3], 1, 1, -1);
					
					VehicleData[vehicleid][Vehicle_Spawn_X] = DealershipOneParks[randIndex][0];
					VehicleData[vehicleid][Vehicle_Spawn_Y] = DealershipOneParks[randIndex][1];
					VehicleData[vehicleid][Vehicle_Spawn_Z] = DealershipOneParks[randIndex][2];
					VehicleData[vehicleid][Vehicle_Spawn_A] = DealershipOneParks[randIndex][3];
				}
				else if(DealershipType[playerid] == 2)
				{
					new randIndex = random(sizeof(DealershipTwoParks));
					vehicleid = AddStaticVehicleEx(VehicleModelPurchasing[playerid], DealershipTwoParks[randIndex][0], DealershipTwoParks[randIndex][1], DealershipTwoParks[randIndex][2], DealershipTwoParks[randIndex][3], 1, 1, -1);
					
					VehicleData[vehicleid][Vehicle_Spawn_X] = DealershipTwoParks[randIndex][0];
					VehicleData[vehicleid][Vehicle_Spawn_Y] = DealershipTwoParks[randIndex][1];
					VehicleData[vehicleid][Vehicle_Spawn_Z] = DealershipTwoParks[randIndex][2];
					VehicleData[vehicleid][Vehicle_Spawn_A] = DealershipTwoParks[randIndex][3];				
				}
				else if(DealershipType[playerid] == 3)
				{
					new randIndex = random(sizeof(DealershipThreeParks));
					vehicleid = AddStaticVehicleEx(VehicleModelPurchasing[playerid], DealershipThreeParks[randIndex][0], DealershipThreeParks[randIndex][1], DealershipThreeParks[randIndex][2], DealershipThreeParks[randIndex][3], 1, 1, -1);
					
					VehicleData[vehicleid][Vehicle_Spawn_X] = DealershipThreeParks[randIndex][0];
					VehicleData[vehicleid][Vehicle_Spawn_Y] = DealershipThreeParks[randIndex][1];
					VehicleData[vehicleid][Vehicle_Spawn_Z] = DealershipThreeParks[randIndex][2];
					VehicleData[vehicleid][Vehicle_Spawn_A] = DealershipThreeParks[randIndex][3];					
				}
				
			    VehicleData[vehicleid][Vehicle_ID] = HasPlayerConfirmedVehicleID[playerid];
		    	VehicleData[vehicleid][Vehicle_Used] = 1;
			    VehicleData[vehicleid][Vehicle_Model] = VehicleModelPurchasing[playerid];
				VehicleData[vehicleid][Vehicle_Color_1] = 1;
				VehicleData[vehicleid][Vehicle_Color_2] = 1;
				VehicleData[vehicleid][Vehicle_Fuel] = 100;
				VehicleData[vehicleid][Vehicle_License_Plate] = 0;

				new ownername[50];
				ownername = GetName(playerid);
				VehicleData[vehicleid][Vehicle_Owner] = ownername;


				if(strlen(VehicleData[vehicleid][Vehicle_License_Plate]) <= 1)
				{
				    new lpstring[10];
				    if(VehicleData[vehicleid][Vehicle_ID] < 10)
				    {
					    format(lpstring, sizeof(lpstring), "ORP 00%i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				    }
				    else if(VehicleData[vehicleid][Vehicle_ID] >= 10 && VehicleData[vehicleid][Vehicle_ID] <= 100)
				    {
					    format(lpstring, sizeof(lpstring), "ORP 0%i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				    }
				    else
				    {
					    format(lpstring, sizeof(lpstring), "ORP %i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
					}

				    new fquery[2000];
			        mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_license_plate` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_License_Plate], VehicleData[vehicleid][Vehicle_ID]);
					mysql_tquery(connection, fquery);
				}

                new fquery[2000];
				mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_owner` = '%s', `vehicle_used` = '1', `vehicle_model` = '%i', `vehicle_color_1` = '%i', `vehicle_color_2` = '%i',`vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Owner], VehicleData[vehicleid][Vehicle_Model], VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2], VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
				mysql_tquery(connection, fquery);

				new licenseplate[10];
				format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
				SetVehicleNumberPlate(vehicleid, licenseplate);
				
				printf("DealershipFindNextFreeVehicleID - Unused ID - Vehicle Updated");

				PlayerData[playerid][Character_Money] -= 25000;
				PlayerData[playerid][Character_Total_Vehicles] ++;

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just purchased a Hermes vehicle, please make you way outside to collect it!");
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

                SetCameraBehindPlayer(playerid);

				VehicleModelPurchasing[playerid] = 0;
			    HasPlayerConfirmedVehicleID[playerid] = 0;
			    IsNewVehicleType[playerid] = 0;

			    VEHICLEPROCESS = 0;
			}
		}
    }
    else
    {
		printf("DealershipFindNextFreeVehicleID - Cannot Find Free Car");
		
        new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT MAX(`vehicle_id`) AS max_id FROM `vehicle_information`");
	    mysql_tquery(connection, query, "DealershipFindNextNewVehicleID", "i", playerid);
    }
    return 1;
}

forward DealershipFindNextNewVehicleID(playerid);
public DealershipFindNextNewVehicleID(playerid)
{
	printf("DealershipFindNextNewVehicleID - Started");
	
    new rows = cache_num_rows();
    new maxID = 0;
    new dstring[256];

    if (rows > 0)
    {
		cache_get_value_name_int(0, "max_id", maxID);
		maxID = maxID + 1;
		
		HasPlayerConfirmedVehicleID[playerid] = maxID;

		printf("DealershipFindNextNewVehicleID - New DB ID %d", HasPlayerConfirmedVehicleID[playerid]);
	
	    IsNewVehicleType[playerid] = 2;
	
		if(HasPlayerConfirmedVehicleID[playerid] > 0)
		{
			printf("DealershipFindNextNewVehicleID - Player has found unique ID - Function Passed");
			
			if(IsNewVehicleType[playerid] == 2)
			{
				printf("DealershipFindNextNewVehicleID - New ID - Record Created");
				
		        new query[128];
			    mysql_format(connection, query, sizeof(query), "INSERT INTO `vehicle_information` (`vehicle_id`, `vehicle_used`) VALUES (%d, '0')", HasPlayerConfirmedVehicleID[playerid]);
			    mysql_tquery(connection, query);
	
				printf("DealershipFindNextNewVehicleID - New ID - Vehicle Created");
				
				new vehicleid;
				new randIndex = random(sizeof(DealershipOneParks));
				vehicleid = AddStaticVehicleEx(VehicleModelPurchasing[playerid], DealershipOneParks[randIndex][0], DealershipOneParks[randIndex][1], DealershipOneParks[randIndex][2], DealershipOneParks[randIndex][3], 1, 1, -1);
	
			    VehicleData[vehicleid][Vehicle_ID] = HasPlayerConfirmedVehicleID[playerid];
		    	VehicleData[vehicleid][Vehicle_Used] = 1;
			    VehicleData[vehicleid][Vehicle_Model] = VehicleModelPurchasing[playerid];
				VehicleData[vehicleid][Vehicle_Color_1] = 1;
				VehicleData[vehicleid][Vehicle_Color_2] = 1;
				VehicleData[vehicleid][Vehicle_Spawn_X] = DealershipOneParks[randIndex][0];
				VehicleData[vehicleid][Vehicle_Spawn_Y] = DealershipOneParks[randIndex][1];
				VehicleData[vehicleid][Vehicle_Spawn_Z] = DealershipOneParks[randIndex][2];
				VehicleData[vehicleid][Vehicle_Spawn_A] = DealershipOneParks[randIndex][3];
				VehicleData[vehicleid][Vehicle_Fuel] = 100;
				VehicleData[vehicleid][Vehicle_License_Plate] = 0;
	
				new ownername[50];
				ownername = GetName(playerid);
				VehicleData[vehicleid][Vehicle_Owner] = ownername;
	
				if(strlen(VehicleData[vehicleid][Vehicle_License_Plate]) <= 1)
				{
				    new lpstring[10];
				    if(VehicleData[vehicleid][Vehicle_ID] < 10)
				    {
					    format(lpstring, sizeof(lpstring), "ORP 00%i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				    }
				    else if(VehicleData[vehicleid][Vehicle_ID] >= 10 && VehicleData[vehicleid][Vehicle_ID] <= 100)
				    {
					    format(lpstring, sizeof(lpstring), "ORP 0%i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				    }
				    else
				    {
					    format(lpstring, sizeof(lpstring), "ORP %i", VehicleData[vehicleid][Vehicle_ID]);
					    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
					}
	
				    new fquery[2000];
			        mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_license_plate` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_License_Plate], VehicleData[vehicleid][Vehicle_ID]);
					mysql_tquery(connection, fquery);
				}
	
	            new fquery[2000];
				mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_owner` = '%s', `vehicle_used` = '1', `vehicle_model` = '%i', `vehicle_color_1` = '%i', `vehicle_color_2` = '%i',`vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Owner], VehicleData[vehicleid][Vehicle_Model], VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2], VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
				mysql_tquery(connection, fquery);
	
				new licenseplate[10];
				format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
				SetVehicleNumberPlate(vehicleid, licenseplate);
				
				printf("DealershipFindNextNewVehicleID - New ID - Vehicle Updated");
	
				PlayerData[playerid][Character_Money] -= 25000;
				PlayerData[playerid][Character_Total_Vehicles] ++;
				
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just purchased a Hermes vehicle, please make you way outside to collect it!");
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
	
	            SetCameraBehindPlayer(playerid);
	
				VehicleModelPurchasing[playerid] = 0;
			    HasPlayerConfirmedVehicleID[playerid] = 0;
			    IsNewVehicleType[playerid] = 0;
	
			    VEHICLEPROCESS = 0;
			} 		
		}
    }	
    return 1;
}

forward CollectNextFreeVehicleID(playerid);
public CollectNextFreeVehicleID(playerid)
{
	printf("CollectNextFreeVehicleID - Started");
	
    new rows = cache_num_rows();
    new nextID = 0;
    new dstring[256];

    if (rows > 0)
    {
		printf("CollectNextFreeVehicleID - Player has found unused ID - Function Passed");
		
		cache_get_value_name_int(0, "vehicle_id", nextID);
        
        HasPlayerConfirmedVehicleID[playerid] = nextID;
        
        IsNewVehicleType[playerid] = 1;
        
		if(IsNewVehicleType[playerid] == 1)
		{
			new Float:px, Float:py, Float:pz, Float:pa;
			new Float:vehx, Float:vehy, Float:vehz, Float:veha;
			
			GetPlayerPos(playerid, px, py, pz);
		    GetPlayerFacingAngle(playerid, pa);
			    
			printf("CollectNextFreeVehicleID - Existing ID - Vehicle Destroyed");
			
		    DestroyVehicle(HasPlayerConfirmedVehicleID[playerid]);

		    new vehicleid;
			vehicleid = AddStaticVehicleEx(vcreatemodel[playerid], px, py, pz, pa, vcreatec1[playerid], vcreatec2[playerid], -1);
			
			printf("CollectNextFreeVehicleID - Existing ID - Vehicle Created");

			PutPlayerInVehicle(playerid, vehicleid, 0);

		    GetVehiclePos(vehicleid, vehx, vehy, vehz);
		    GetVehicleZAngle(vehicleid, veha);

		    VehicleData[vehicleid][Vehicle_ID] = HasPlayerConfirmedVehicleID[playerid];
	    	VehicleData[vehicleid][Vehicle_Used] = 1;
		    VehicleData[vehicleid][Vehicle_Model] = vcreatemodel[playerid];
			VehicleData[vehicleid][Vehicle_Color_1] = vcreatec1[playerid];
			VehicleData[vehicleid][Vehicle_Color_2] = vcreatec2[playerid];

			VehicleData[vehicleid][Vehicle_Spawn_X] = vehx;
			VehicleData[vehicleid][Vehicle_Spawn_Y] = vehy;
			VehicleData[vehicleid][Vehicle_Spawn_Z] = vehz;
			VehicleData[vehicleid][Vehicle_Spawn_A] = veha;

			VehicleData[vehicleid][Vehicle_Fuel] = 100;

			if(strlen(VehicleData[vehicleid][Vehicle_License_Plate]) <= 1)
			{
			    new lpstring[10];
			    if(VehicleData[vehicleid][Vehicle_ID] < 10)
			    {
				    format(lpstring, sizeof(lpstring), "ORP 00%i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
			    }
			    else if(VehicleData[vehicleid][Vehicle_ID] >= 10 && VehicleData[vehicleid][Vehicle_ID] <= 100)
			    {
				    format(lpstring, sizeof(lpstring), "ORP 0%i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
			    }
			    else
			    {
				    format(lpstring, sizeof(lpstring), "ORP %i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				}

			    new fquery[2000];
		        mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_license_plate` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_License_Plate], VehicleData[vehicleid][Vehicle_ID]);
				mysql_tquery(connection, fquery);
			}

            new fquery[2000];
			mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_used` = '1', `vehicle_model` = '%i', `vehicle_color_1` = '%i', `vehicle_color_2` = '%i',`vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Model], VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2], VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
			mysql_tquery(connection, fquery);

			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
			
			printf("CollectNextFreeVehicleID - Existing ID - Vehicle Updated");

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just used an existing unused vehicle! %d", VehicleData[vehicleid][Vehicle_ID]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
				
			HasPlayerConfirmedVehicleID[playerid] = 0;
			IsNewVehicleType[playerid] = 0;
		}
    }
    else
    {
		printf("CollectNextNewIDValue - Started");
		
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT MAX(`vehicle_id`) AS max_id FROM `vehicle_information`");
	    mysql_tquery(connection, query, "CollectNextNewIDValue");
    }
    return 1;
}

forward CollectNextNewIDValue(playerid);
public CollectNextNewIDValue(playerid)
{
    new rows = cache_num_rows();
    new maxID = 0;
    new dstring[256];

    if (rows > 0)
    {
		printf("CollectNextNewIDValue - New Vehicle ID Found - Function Passed");
		
		cache_get_value_name_int(0, "max_id", maxID);
		maxID = maxID + 1;
		
		HasPlayerConfirmedVehicleID[playerid] = maxID;
    
    	IsNewVehicleType[playerid] = 2;

		if(IsNewVehicleType[playerid] == 2)
		{
			new Float:px, Float:py, Float:pz, Float:pa;
			new Float:vehx, Float:vehy, Float:vehz, Float:veha;
			
			new query[128];
		    mysql_format(connection, query, sizeof(query), "INSERT INTO `vehicle_information` (`vehicle_id`, `vehicle_used`) VALUES (%d, '0')", HasPlayerConfirmedVehicleID[playerid]);
		    mysql_tquery(connection, query);
		
			printf("CollectNextNewIDValue - New Vehicle ID - Record Created");
				
			GetPlayerPos(playerid, px, py, pz);
		    GetPlayerFacingAngle(playerid, pa);
		    
		    new vehicleid;
			vehicleid = AddStaticVehicleEx(vcreatemodel[playerid], px, py, pz, pa, vcreatec1[playerid], vcreatec2[playerid], -1);
			
			printf("CollectNextNewIDValue - New Vehicle ID - Vehicle Created");

			PutPlayerInVehicle(playerid, vehicleid, 0);

		    GetVehiclePos(vehicleid, vehx, vehy, vehz);
		    GetVehicleZAngle(vehicleid, veha);

		    VehicleData[vehicleid][Vehicle_ID] = HasPlayerConfirmedVehicleID[playerid];
	    	VehicleData[vehicleid][Vehicle_Used] = 1;
		    VehicleData[vehicleid][Vehicle_Model] = vcreatemodel[playerid];
			VehicleData[vehicleid][Vehicle_Color_1] = vcreatec1[playerid];
			VehicleData[vehicleid][Vehicle_Color_2] = vcreatec2[playerid];

			VehicleData[vehicleid][Vehicle_Spawn_X] = vehx;
			VehicleData[vehicleid][Vehicle_Spawn_Y] = vehy;
			VehicleData[vehicleid][Vehicle_Spawn_Z] = vehz;
			VehicleData[vehicleid][Vehicle_Spawn_A] = veha;
				
			VehicleData[vehicleid][Vehicle_Fuel] = 100;
				
			if(strlen(VehicleData[vehicleid][Vehicle_License_Plate]) <= 1)
			{
			    new lpstring[10];
			    if(VehicleData[vehicleid][Vehicle_ID] < 10)
			    {
				    format(lpstring, sizeof(lpstring), "ORP 00%i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
			    }
			    else if(VehicleData[vehicleid][Vehicle_ID] >= 10 && VehicleData[vehicleid][Vehicle_ID] <= 100)
			    {
				    format(lpstring, sizeof(lpstring), "ORP 0%i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
			    }
			    else
			    {
				    format(lpstring, sizeof(lpstring), "ORP %i", VehicleData[vehicleid][Vehicle_ID]);
				    VehicleData[vehicleid][Vehicle_License_Plate] = lpstring;
				}
				    
			    new fquery[2000];
		        mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_license_plate` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_License_Plate], VehicleData[vehicleid][Vehicle_ID]);
				mysql_tquery(connection, fquery);
			}

            new fquery[2000];
			mysql_format(connection, fquery, sizeof(fquery), "UPDATE `vehicle_information` SET `vehicle_used` = '1', `vehicle_model` = '%i', `vehicle_color_1` = '%i', `vehicle_color_2` = '%i',`vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Model], VehicleData[vehicleid][Vehicle_Color_1], VehicleData[vehicleid][Vehicle_Color_2], VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
			mysql_tquery(connection, fquery);
				
			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
			
			printf("CollectNextNewIDValue - New Vehicle ID - Vehicle Updated");

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just created a new vehicle! %d", VehicleData[vehicleid][Vehicle_ID]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			HasPlayerConfirmedVehicleID[playerid] = 0;
			IsNewVehicleType[playerid] = 0;
		}
    }
    return 1;
}

forward DynamicDoorEntry(playerid);
public DynamicDoorEntry(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerInHospital[playerid] == 1) return SendPlayerErrorMessage(playerid, " You cannot leave the hospital just yet, please wait one minute before leaving!");
	    if(IsPlayerNearDynamicDoor(playerid))
	    {
	        new ddoorid = PlayerAtDoorID[playerid];
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, DoorData[ddoorid][Door_Outside_X], DoorData[ddoorid][Door_Outside_Y], DoorData[ddoorid][Door_Outside_Z]) && DoorData[ddoorid][Door_Faction] > 0 && PlayerData[playerid][Character_Faction] != DoorData[ddoorid][Door_Faction])
	        {
                new tdstring1[500];
	    		format(tdstring1, sizeof(tdstring1), "~r~You Cannot Use This Door!");
				PlayerTextDrawSetString(playerid, PlayerText:Notification_Textdraw, tdstring1);
				PlayerTextDrawShow(playerid, PlayerText:Notification_Textdraw);

		        Notification_Timer[playerid] = SetTimerEx("OnTimerCancels", 4000, false, "i", playerid);
	        }
	        else if(IsPlayerInRangeOfPoint(playerid, 1.5, DoorData[ddoorid][Door_Inside_X], DoorData[ddoorid][Door_Inside_Y], DoorData[ddoorid][Door_Inside_Z]) && DoorData[ddoorid][Door_Faction] > 0 && PlayerData[playerid][Character_Faction] != DoorData[ddoorid][Door_Faction])
	        {
                new tdstring1[500];
	    		format(tdstring1, sizeof(tdstring1), "~r~You Cannot Use This Door!");
				PlayerTextDrawSetString(playerid, PlayerText:Notification_Textdraw, tdstring1);
				PlayerTextDrawShow(playerid, PlayerText:Notification_Textdraw);

		        Notification_Timer[playerid] = SetTimerEx("OnTimerCancels", 4000, false, "i", playerid);
	        }
	        else if(IsPlayerInRangeOfPoint(playerid, 1.5, DoorData[ddoorid][Door_Outside_X], DoorData[ddoorid][Door_Outside_Y], DoorData[ddoorid][Door_Outside_Z]))
			{
			    if(DoorData[ddoorid][Door_Inside_X] == 0)
			    {
			        SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
				   	SetPlayerInterior(playerid, 0);
				    SetPlayerVirtualWorld(playerid, 0);
				    
				    SendClientMessage(playerid, COLOR_YELLOW, "Your character has entered a door with no exit parameters set, please report to the admins!");
			    }
			    else
			    {
					SetPlayerPos(playerid, DoorData[ddoorid][Door_Inside_X], DoorData[ddoorid][Door_Inside_Y], DoorData[ddoorid][Door_Inside_Z]);
					SetPlayerInterior(playerid, DoorData[ddoorid][Door_Inside_Interior]);
					SetPlayerVirtualWorld(playerid, DoorData[ddoorid][Door_Inside_VW]);

					SetPlayerFacingAngle(playerid, DoorData[ddoorid][Door_Inside_A]);

	                PlayerAtDoorID[playerid] = 0;

	                TogglePlayerControllable(playerid,false);
					DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
				}
			}
   			else if(IsPlayerInRangeOfPoint(playerid, 1.5, DoorData[ddoorid][Door_Inside_X], DoorData[ddoorid][Door_Inside_Y], DoorData[ddoorid][Door_Inside_Z]))
			{
			    if(DoorData[ddoorid][Door_Inside_X] == 0)
			    {
			        SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
				   	SetPlayerInterior(playerid, 0);
				    SetPlayerVirtualWorld(playerid, false);
				    
				    SendClientMessage(playerid, COLOR_YELLOW, "Your character has entered a door with no exit parameters set, please report to the admins!");
			    }
			    else
			    {
					SetPlayerPos(playerid, DoorData[ddoorid][Door_Outside_X], DoorData[ddoorid][Door_Outside_Y], DoorData[ddoorid][Door_Outside_Z]);
					SetPlayerInterior(playerid, DoorData[ddoorid][Door_Outside_Interior]);
					SetPlayerVirtualWorld(playerid, DoorData[ddoorid][Door_Outside_VW]);

					SetPlayerFacingAngle(playerid, DoorData[ddoorid][Door_Outside_A]);

					PlayerAtDoorID[playerid] = 0;
				}
   			}
	    }
	    
	    if(IsPlayerNearHouseDoor(playerid))
	    {
	    	new hdoorid = PlayerAtHouseID[playerid];

	        if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z]) && HouseData[hdoorid][House_Inside_X] != 0)
			{
				if(HouseData[hdoorid][House_Lock_Active] == 1) return SendPlayerErrorMessage(playerid, " You cannot enter a locked house!");
				
				if(HouseData[hdoorid][House_Alarm_Active] == 1)
				{
					HOUSE_ALARM_ID = hdoorid;
										
	                new dstring[256];
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: A property alarm has just been activated [/acceptjob 2])");
					SendFactionRadioMessage(1, COLOR_WHITE, dstring);
				}
				
			    SetPlayerPos(playerid, HouseData[hdoorid][House_Inside_X], HouseData[hdoorid][House_Inside_Y], HouseData[hdoorid][House_Inside_Z]);
				SetPlayerInterior(playerid, HouseData[hdoorid][House_Inside_Interior]);
				SetPlayerVirtualWorld(playerid, HouseData[hdoorid][House_Inside_VW]);
				SetPlayerFacingAngle(playerid, HouseData[hdoorid][House_Inside_A]);

                PlayerAtHouseID[playerid] = 0;

                TogglePlayerControllable(playerid,false);
				DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
			}
         	else if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z]) && HouseData[hdoorid][House_Inside_X] == 0)
			{
				if(HouseData[hdoorid][House_Lock_Active] == 1) return SendPlayerErrorMessage(playerid, " You cannot enter a locked house!");
				
				if(HouseData[hdoorid][House_Alarm_Active] == 1)
				{
					HOUSE_ALARM_ID = hdoorid;
										
	                new dstring[256];
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: A property alarm has just been activated)");
					SendFactionRadioMessage(1, COLOR_WHITE, dstring);
				}
				
				SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
			   	SetPlayerInterior(playerid, 0);
			    SetPlayerVirtualWorld(playerid, 0);

                PlayerAtHouseID[playerid] = 0;

                SendPlayerErrorMessage(playerid, " Your character has entered a house with no exit parameters set, please report to the admins!");

                TogglePlayerControllable(playerid,false);
				DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
			}
   			else if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseData[hdoorid][House_Inside_X], HouseData[hdoorid][House_Inside_Y], HouseData[hdoorid][House_Inside_Z]))
			{
				SetPlayerPos(playerid, HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z]);
				SetPlayerInterior(playerid, HouseData[hdoorid][House_Outside_Interior]);
				SetPlayerVirtualWorld(playerid, HouseData[hdoorid][House_Outside_VW]);
				SetPlayerFacingAngle(playerid, HouseData[hdoorid][House_Outside_A]);

				PlayerAtHouseID[playerid] = 0;
   			}
	    }
	    if(IsPlayerNearBusinessDoor(playerid))
	    {
	    	new bdoorid = PlayerAtBusinessID[playerid];
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]) && HouseData[bdoorid][House_Inside_X] != 0)
			{
				SetPlayerPos(playerid, BusinessData[bdoorid][Business_Inside_X], BusinessData[bdoorid][Business_Inside_Y], BusinessData[bdoorid][Business_Inside_Z]);
				SetPlayerInterior(playerid, BusinessData[bdoorid][Business_Inside_Interior]);
				SetPlayerVirtualWorld(playerid, BusinessData[bdoorid][Business_Inside_VW]);
				SetPlayerFacingAngle(playerid, BusinessData[bdoorid][Business_Inside_A]);

                PlayerAtBusinessID[playerid] = 0;

                TogglePlayerControllable(playerid,false);
				DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 1.5, BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]) && HouseData[bdoorid][House_Inside_X] != 0)
			{
			    SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
			   	SetPlayerInterior(playerid, 0);
			    SetPlayerVirtualWorld(playerid, 0);

                PlayerAtBusinessID[playerid] = 0;

                SendPlayerErrorMessage(playerid, " Your character has entered a business with no exit parameters set, please report to the admins!");

                TogglePlayerControllable(playerid,false);
				DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
			}
   			else if(IsPlayerInRangeOfPoint(playerid, 1.5, BusinessData[bdoorid][Business_Inside_X], BusinessData[bdoorid][Business_Inside_Y], BusinessData[bdoorid][Business_Inside_Z]))
			{
				SetPlayerPos(playerid, BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]);
				SetPlayerInterior(playerid, BusinessData[bdoorid][Business_Outside_Interior]);
				SetPlayerVirtualWorld(playerid, BusinessData[bdoorid][Business_Outside_VW]);
				SetPlayerFacingAngle(playerid, BusinessData[bdoorid][Business_Outside_A]);

				PlayerAtBusinessID[playerid] = 0;
   			}
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 1.5, 1498.2710,-1581.8063,13.5498))
     	{
			if(PlayerData[playerid][Character_Hotel_ID] == 1)
   			{
		    	SetPlayerPos(playerid, 267.2495,304.6546,999.1484);
				SetPlayerInterior(playerid, 2);
				SetPlayerVirtualWorld(playerid, PlayerData[playerid][Hotel_Character_Virtual_World]);
				SetPlayerFacingAngle(playerid, 277.2628);

                TogglePlayerControllable(playerid,false);
				DoorEntry_Timer[playerid] = SetTimerEx("DoorDelayTimer", 2000, false, "i", playerid);
            }
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 267.2495,304.6546,999.1484))
     	{
			if(PlayerData[playerid][Character_Hotel_ID] == 1)
   			{
		    	SetPlayerPos(playerid, 1498.2710,-1581.8063,13.5498);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerFacingAngle(playerid, 355.2835);
            }
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2142.4463,1626.2913,993.6882) && PlayerData[playerid][Character_Faction] == 1)
	    {
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.0, false, false, false, false, 0, SYNC_ALL);

	        new string[256];
	        format(string, sizeof(string), "> %s pulls their ID out of their pocket and swipes it on the pad", GetName(playerid));
	   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

	        if(BankDoorOpen == true)
	        {
	            MoveDynamicObject(BankDoor, 2144.19385, 1627.00122, 994.24762, 0.1, 0.00000, 0.00000, 180.00000);
				BankDoorOpen = false;
	        }
	        else if(BankDoorOpen == false)
	        {
	            MoveDynamicObject(BankDoor, 2145.1274, 1626.2031, 994.2476, 0.1, 0.00000, 0.00000, 270.00000);
	            BankDoorOpen = true;
	        }
	    }
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1777.9543, -1700.9966, 13.3870) && PlayerData[playerid][Character_Faction] == 2)
	    {
	        ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.0, false, false, false, false, 0, SYNC_ALL);
	        
	        new string[256];
	        format(string, sizeof(string), "> %s pulls their ID out of their pocket and swipes it on the pad", GetName(playerid));
	   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        
	        if(LSFDGarageDoorOpen == true)
	        {
	            MoveDynamicObject(LSFDGarageDoor, 1775.91125, -1701.51245, 12.24770, 1, 0, 0, 0);
	            LSFDGarageDoorOpen = false;
	        }
	        else if(LSFDGarageDoorOpen == false)
	        {
	            MoveDynamicObject(LSFDGarageDoor, 1773.91125, -1701.51245, 12.24770, 1, 0, 0, 0);
	            LSFDGarageDoorOpen = true;
	        }
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1782.9009, -1705.1691, 16.7503) && PlayerData[playerid][Character_Faction] == 2)
	    {
	        ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.0, false, false, false, false, 0, SYNC_ALL);
	        
	        new string[256];
	        format(string, sizeof(string), "> %s pulls their ID out of their pocket and swipes it on the pad", GetName(playerid));
	   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        
	        if(LSFDTopDoorOpen == true)
	        {
	            MoveDynamicObject(LSFDTopDoor, 1782.34351, -1707.03296, 15.71100, 1, 0, 0, 90.00000);
	            LSFDTopDoorOpen = false;
	        }
	        else if(LSFDTopDoorOpen == false)
	        {
	            MoveDynamicObject(LSFDTopDoor, 1782.34351, -1709.03296, 15.71100, 1, 0, 0, 90.00000);
	            LSFDTopDoorOpen = true;
	        }
	    }
	}
	return 1;
}

forward LoadPlayerMDCLines();
public LoadPlayerMDCLines()
{
	new sloaded = 1;
    while(sloaded <= MAX_CRIMES)
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `player_mdc_information` WHERE `mdc_crime_report_id` = '%i' LIMIT 1", sloaded);
    	mysql_tquery(connection, query, "LoadPlayerMDCLines_Results");

    	sloaded++;
	}
	printf("Server: Crimes loaded into the server");
	return 1;
}

forward LoadPlayerMDCLines_Results();
public LoadPlayerMDCLines_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded;
		cache_get_value_name_int(0, "mdc_crime_report_id", loaded);
		
		cache_get_value_name_int(0, "mdc_crime_report_id", PlayerMDCData[loaded][MDC_Crime_Report_ID]);
		cache_get_value_name(0, "mdc_crime_character_name", PlayerMDCData[loaded][MDC_Crime_Character_Name], 50);
		cache_get_value_name(0, "mdc_crime_desc", PlayerMDCData[loaded][MDC_Crime_Desc], 150);
		cache_get_value_name_int(0, "mdc_crime_alert", PlayerMDCData[loaded][MDC_Crime_Alert]);
	}
	return 1;
}

/* -------------- START OF STOCK FUNCTIONS FOR THE SCRIPT ---------------------- */

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if(IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if(IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock IsTruckVehicle(vehicleModel)
{
    for (new i = 0; i < TRUCK_VEHICLE_MODELS_COUNT; i++)
    {
        if (truckVehicleModels[i] == vehicleModel)
        {
            return 1;
        }
    }
    return 0;
}

stock IsMotorcycle(vehicleModel)
{
    for (new i = 0; i < MOTORCYCLE_MODELS_COUNT; i++)
    {
        if (motorcycleModels[i] == vehicleModel)
        {
            return 1;
        }
    }
    return 0;
}

stock IsAircraft(vehicleModel)
{
    for (new i = 0; i < AIRCRAFT_MODELS_COUNT; i++)
    {
        if (aircraftModels[i] == vehicleModel)
        {
            return 1;
        }
    }
    return 0;
}

stock IsBoat(vehicleModel)
{
    for (new i = 0; i < BOAT_MODELS_COUNT; i++)
    {
        if (boatModels[i] == vehicleModel)
        {
            return 1;
        }
    }
    return 0;
}

stock GetValidHouseJobNumber()
{
    new randomNumber;
    do
    {
        randomNumber = random(MAX_HOUSES) + 1;
    }
    while (HouseData[randomNumber][House_Outside_X] == 0);

    return randomNumber;
}

stock GetValidMechanicJobNumber()
{
    new randomNumber;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    do
    {
        randomNumber = random(MAX_VEHICLES) + 1;
        GetVehicleParamsEx(randomNumber, engine, lights, alarm, doors, bonnet, boot, objective);
    }
    while (VehicleData[randomNumber][Vehicle_Used] == 0 && engine == 0);

    return randomNumber;
}

stock IsPlayerAtBootOfVehicle(playerid, vehicleid)
{
    new Float:playerPos[3];
    GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

    vehicleid = GetClosestVehicle(playerPos[0], playerPos[1], playerPos[2]);

    if (vehicleid == 0)
        return 0;

    new Float:vehiclePos[3], Float:vehicleRotation[3];
    GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
    GetVehicleRotation(vehicleid, vehicleRotation[0], vehicleRotation[1], vehicleRotation[2]);

    new Float:backPos[3];
    backPos[0] = vehiclePos[0] - 1.5 * floatcos(vehicleRotation[2]);
    backPos[1] = vehiclePos[1] - 1.5 * floatsin(vehicleRotation[2]);
    backPos[2] = vehiclePos[2];

    if (GetDistanceBetweenCoords(playerPos[0], playerPos[1], playerPos[2],
                                  backPos[0], backPos[1], backPos[2]) < 1.0)
    {
        return 1;
    }

    return 0;
}

stock GetNearestVehicleModel(playerid, modelId)
{
    new 
        Float:fPos[3],
        Float:closestDistance = 100.0,
        Float:curDistance,
        closestVehicle = INVALID_VEHICLE_ID;

    for (new v = 0; v < MAX_VEHICLES; v++)
    {
        if (v != INVALID_VEHICLE_ID)
        {
            GetVehiclePos(v, fPos[0], fPos[1], fPos[2]);
            curDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);

            if (curDistance < closestDistance && GetVehicleModel(v) == modelId)
            {
                closestVehicle = v;
                closestDistance = curDistance;
            }
        }
    }

    return closestVehicle;
}

stock GetClosestVehicleModel(playerid)
{
    new vehicleId = GetClosestVehicle(playerid);
    
    if (vehicleId != INVALID_VEHICLE_ID)
    {
        return GetVehicleModel(vehicleId);
    }
    
    return 0;
}

stock GetClosestVehicle(playerid)
{
    new
        Float:fPos[3],
        Float:distance = 10,
        Float:curdistance,
        currentVehicle;

    for(new v = 0; v < MAX_VEHICLES; v++)
    {
        GetVehiclePos(v, fPos[0], fPos[1], fPos[2]);
        curdistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);

        if(curdistance < distance)
        {
            currentVehicle = v;
            distance = curdistance;
        }
    }
    return currentVehicle;
}

stock IsDrivingVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Type] == 3)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsRentalVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Type] == 2)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsGarbageVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Job] == 2)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsPizzaVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Job] == 1)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsElectricianVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Job] == 3)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsBankVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 4)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsTowVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 5)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsTaxiVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 6)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsTruckCoVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 7)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsDudeFixVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 8)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsGang1Vehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 10)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsGang2Vehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 11)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsGang3Vehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 12)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsGang4Vehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 13)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsLSPDVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 1)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsLSFDVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 2)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsLSMCVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 3)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock IsMechanicVehicle(playerid)
{
    new vehicle_handle = GetPlayerVehicleID(playerid);

    if (vehicle_handle == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        if (VehicleData[i][Vehicle_ID] == vehicle_handle)
        {
            if (VehicleData[i][Vehicle_Faction] == 9)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    return 0;
}

stock GetVehicleModelName(modelID)
{
	new vehiclesName[25];
	if(modelID >= 400 && modelID <= 612)
	{
	    format(vehiclesName, sizeof(vehiclesName), "%s", VehicleModelNames[modelID - 400]);
	}
	return vehiclesName;
}

stock bool:IsEqual(const str1[], const str2[], bool:ignorecase = false) {
    new
        c1 = (str1[0] > 255) ? str1{0} : str1[0],
        c2 = (str2[0] > 255) ? str2{0} : str2[0]
    ;

    if (!c1 != !c2)
        return false;

    return !strcmp(str1, str2, ignorecase);
}
 
stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock SendHelpMeMessage(color, const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Helper_Level] >= 1 && HasPlayerToggledHelpMe[i] == 0 || PlayerData[i][Moderator_Level] >= 1 && HasPlayerToggledHelpMe[i] == 0 || PlayerData[i][Admin_Level] >= 1 && HasPlayerToggledHelpMe[i] == 0)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock SendReportMessage(color, const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Moderator_Level] >= 1 || PlayerData[i][Admin_Level] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock SendHelperMessage(color, const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Helper_Level] >= 1 || PlayerData[i][Moderator_Level] >= 1 || PlayerData[i][Admin_Level] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock SendModeratorMessage(color, const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Moderator_Level] >= 1 || PlayerData[i][Admin_Level] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock SendAdminMessage(color, const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Admin_Level] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock SendFactionOOCMessage(factionid, color, const str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Character_Faction] == factionid)
			{
			    SendClientMessage(i, color, str);
			}
		}
	}
	return 1;
}

stock SendFactionRadioMessage(factionid, color, const str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Character_Faction] == factionid)
			{
			    if(IsPlayerOnDuty[i] == 1)
			    {
			    	SendClientMessage(i, color, str);
				}
			}
		}
	}
	return 1;
}

stock SendGovRadioMessage(color, const str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Character_Faction] == 1 || PlayerData[i][Character_Faction] == 2 || PlayerData[i][Character_Faction] == 3 || PlayerData[i][Character_Faction] == 5)
			{
			    if(IsPlayerOnDuty[i] == 1)
			    {
			    	SendClientMessage(i, color, str);
				}
			}
		}
	}
	return 1;
}

stock SendGroupRadioMessage(radiofreq, color, const str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[i][Character_Radio] == radiofreq)
			{
			    SendClientMessage(i, color, str);
			}
		}
	}
	return 1;
}

stock ClearMessages(playerid)
{
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
    SendClientMessage(playerid, COLOR_YELLOW, "");
	return 1;
}
stock GetVehicleSpeed(vehicleid)
{
    new Float:x, Float:y, Float:z, vel;
    GetVehicleVelocity(vehicleid, x, y, z);
    vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 );
    return vel;
}

/* -------------- START OF GAMEPLAY CONTROLS FOR USERS ---------------------- */

// ANIMATION COMMANDS

CMD:stopanim(playerid, params[])
{
	if(IsPlayerInjured[playerid] == 0)
	{
		ClearAnimations(playerid);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);	
	}
	return 1;
}

CMD:bodypush(playerid, params[])
{
	ApplyAnimation(playerid, "GANGS", "shake_cara", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:lowbodypush(playerid, params[])
{
	ApplyAnimation(playerid, "GANGS", "shake_carSH", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:headbutt(playerid, params[])
{
	ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:airkick(playerid, params[])
{
	ApplyAnimation(playerid, "FIGHT_C", "FightC_M", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:doorkick(playerid, params[])
{
	ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:leftslap(playerid, params[])
{
	ApplyAnimation(playerid, "ped", "BIKE_elbowL", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:elbow(playerid, params[])
{
	ApplyAnimation(playerid, "FIGHT_D", "FightD_3", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:coprun(playerid, params[])
{
	ApplyAnimation(playerid, "SWORD", "sword_block", 4.0, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:handsup(playerid, params[])
{
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:piss(playerid, params[])
{
   	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
	return 1;
}

CMD:sneak(playerid, params[])
{	
	ApplyAnimation(playerid, "ped", "Player_Sneak", 4.1, true, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:drunk(playerid, params[])
{
	ApplyAnimation(playerid, "ped", "WALK_drunk", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:bomb(playerid, params[])
{
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:robbing(playerid, params[])
{	
	ApplyAnimation(playerid, "ped", "ARRESTgun", 4.1, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:laugh(playerid, params[])
{	
	ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, false, false, false, false, 0, SYNC_ALL);
	return 1;
}

CMD:lookout(playerid, params[])
{
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:robman(playerid, params[])
{
	ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:hide(playerid, params[])
{
	ApplyAnimation(playerid, "ped", "cower", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:vomit(playerid, params[])
{
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:eat(playerid, params[])
{
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:slapass(playerid, params[])
{
	ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:fuckyou(playerid, params[])
{
	ApplyAnimation(playerid, "ped", "fucku", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:sleep(playerid, params[])
{
	ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:wavedown(playerid, params[])
{
	ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:cpr(playerid, params[])
{
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:throw(playerid, params[])
{
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:robbed(playerid, params[])
{
	ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:hurt(playerid, params[])
{
	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.1, true, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:fallover(playerid, params[])
{
	ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:smoke(playerid, params[])
{
	ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:crossarms(playerid, params[])
{
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, false, false, false, false, 0, SYNC_ALL);
    return 1;
}

CMD:sit(playerid, params[])
{
	switch(strval(params))
	{
	case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.1, true, false, false, false, 0, SYNC_ALL);
	case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, true, false, false, false, 0, SYNC_ALL);
	case 3: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.1, true, false, false, false, 0, SYNC_ALL);
	case 4: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.1, true, false, false, false, 0, SYNC_ALL);
	case 5: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.1, true, false, false, false, 0, SYNC_ALL);
	default: SendPlayerServerMessage(playerid, " /sit [1-5]");
	}
	return 1;
}

CMD:dance(playerid, params[])
{
	switch(strval(params))
	{
	case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	default: SendPlayerServerMessage(playerid, " /dance [1-4]");
	}
	return 1;
}


// GENERAL SETTINGS COMMANDS

CMD:unstuck(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(IsPlayerCuffed[playerid] == 1 || IsPlayerTied[playerid] == 1) return SendPlayerErrorMessage(playerid, " You cannot use this command while tied or handcuffed!");
	else
	{
	    TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
		
		if(VEHICLEPROCESS == 1 && VehicleModelPurchasing[playerid] != 0)
		{
			VEHICLEPROCESS = 0;
            HasPlayerConfirmedVehicleID[playerid] = 0;
			VehicleModelPurchasing[playerid] = 0;
		}
		
		if(IsPlayerInViewState_Binco[playerid] == 1)
		{
			Binco_Current_Outfit[playerid] = 0;
			Binco_Current_VW[playerid] = 0;
					
			IsPlayerInViewState_Binco[playerid] = 0;
		}
		
		new dstring1[156];
		format(dstring1, sizeof(dstring1), "> You have just submitted a help me request, please stand by for a private message!");
		SendClientMessage(playerid, COLOR_YELLOW, dstring1);
	}
	return 1;
}

CMD:paymenttype(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	else
	{
	    if(PlayerDefaultPayment[playerid] == 1)
		{
			PlayerDefaultPayment[playerid] = 2;
			
			new dstring1[156];
			format(dstring1, sizeof(dstring1), "> You have just switched to paying with [COINS], this will effect only buying houses, businesses or factions!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring1);
		}
		else if(PlayerDefaultPayment[playerid] == 2)
		{
			PlayerDefaultPayment[playerid] = 1;
			
			new dstring1[156];
			format(dstring1, sizeof(dstring1), "> You have just switched to paying with [MONEY], this will effect only buying houses, businesses or factions!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring1);
		}
	}
	return 1;
}

CMD:changepassword(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new password[129];

		if(sscanf(params, "s[129]", password))
		{
			SendPlayerServerMessage(playerid, " /changepassword [newpassword]");
   		}
		else
		{			
		    new acquery[2000];
	        mysql_format(connection, acquery, sizeof(acquery), "UPDATE `user_accounts` SET `character_password` = '%s' WHERE `character_name` = '%e' LIMIT 1", password, PlayerData[playerid][Character_Name]);
    		mysql_tquery(connection, acquery);

		    new dstring[500];
			format(dstring, sizeof(dstring), "> You have just changed your password");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
		}
	}
	return 1;
}

// GENERAL CHAT COMMANDS
CMD:me(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /me [ACTION]");

   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s %s", GetName(playerid), params);
   	
   	printf("CMD_ME: %s", params);
   	
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /do [ACTION]");
	
 	new string[128];
  	format(string, sizeof(string), "((> %s %s))", GetName(playerid), params);
   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   	
   	printf("CMD_DO: %s", string);
   	
	return 1;
}

CMD:whisper(playerid, params[]) return cmd_w(playerid,params);
CMD:w(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /w(hisper) [TEXT]");
    
	new message[128];
 	format(message, sizeof(message), "%s whispers: %s", GetName(playerid), params);
    SendNearbyMessage(playerid, 15.0, COLOR_WHITE, message);
	
	printf("WhisperChat: %s", message);
	
	return 1;
}

CMD:shout(playerid, params[]) return cmd_s(playerid,params);
CMD:s(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /s(hout) [TEXT]");
    
	new message[128];
 	format(message, sizeof(message), "%s shouts: %s", GetName(playerid), params);
    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);
	
	printf("ShoutChat: %s", message);
	
	return 1;
}

CMD:pm(playerid, params[])
{
	new targetid, message[250];

	if(sscanf(params, "is[250]", targetid, message))
	{
		SendPlayerServerMessage(playerid, " /pm [targetid] [message]");
	}
	else
	{
		if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot private message yourself!");
		if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
		
		new dstring[500];
		format(dstring, sizeof(dstring), "(PM from %s (ID: %d): %s)", GetName(playerid), playerid, message);
		SendClientMessage(targetid, COLOR_YELLOW, dstring);
		
		new dstring1[500];
		format(dstring1, sizeof(dstring1), "(PM to %s (ID: %d): %s)", GetName(targetid), targetid, message);
		SendClientMessage(playerid, COLOR_YELLOW, dstring1);
	}
	return 1;
}

CMD:clearchat(playerid, params)
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    ClearMessages(playerid);
	}
	return 1;
}

CMD:ooc(playerid, params[]) return cmd_o(playerid,params);
CMD:o(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /o(oc) [TEXT]");

	new message[128];
 	format(message, sizeof(message), "([OOC] %s: %s )", GetName(playerid), params);
	SendNearbyMessage(playerid, 30.0, COLOR_WHITE, message);

    printf("OOCChat: %s", message);
    
	return 1;
}

CMD:global(playerid, params[]) return cmd_g(playerid,params);
CMD:g(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /g(lobal) [TEXT]");
	if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
    if(GLOBALCHAT == 1) return SendPlayerErrorMessage(playerid, " You cannot use this feature at the moment. No admin has enabled global chat");

	new message[128];
 	format(message, sizeof(message), "([GLOBAL CHAT] %s: %s )", GetName(playerid), params);
	SendClientMessageToAll(COLOR_ORANGE, message);

	printf("GlobalChat: %s", message);
	
	return 1;
}

CMD:helpme(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /helpme [Question]");
	if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
    if(IsPlayerInHelpMeCooldown[playerid] == 1) return SendPlayerErrorMessage(playerid, " You have sent a helpme request already, please wait a short period before submitting another one!");
	
	new dstring1[156];
	format(dstring1, sizeof(dstring1), "> You have just submitted a help me request, please stand by for a private message!");
	SendClientMessage(playerid, COLOR_YELLOW, dstring1);
	
	IsPlayerInHelpMeCooldown[playerid] = 1;
	Cooldown_Timer[playerid] = SetTimerEx("Cooldown_Helpme_Timer", 15000, false, "i", playerid);
	
	new string[500];
	format(string, sizeof(string), "[HELP QUESTION]:{FFFFFF} %s (ID:%d) asked: %s", GetName(playerid), playerid, params);
	SendHelpMeMessage(COLOR_AQUABLUE, string);
	
	printf("Helpme Question: %s asks %s", GetName(playerid), params);
	
	return 1;
}

// GENERAL PLAYER COMMANDS
CMD:mask(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(PlayerData[playerid][Character_Has_Mask] == 0) return SendPlayerErrorMessage(playerid, " You do not have a mask!");
		else
    	{
			if(HasPlayerUsedMask[playerid] == 0)
			{
				new FindMaskID, found, Float:x, Float:y, Float:z, vw;
				FindMaskID = 10000 + random(100000);
				found = 0;
				
				GetPlayerPos(playerid, x, y, z);
				vw = GetPlayerVirtualWorld(playerid);
				
				while(!found)
				{
					FindMaskID = 10000 + random(100000);
					found = 1;
					
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(HasPlayerUsedMask[i] == FindMaskID)
						{						
							found = 0;
							break;
						}
					}
				}
				
				HasPlayerUsedMask[playerid] = FindMaskID;
				
				textLabelID[playerid] = Create3DTextLabel("Stranger %d", 0xFFFFFFFF, x, y, z + 1.0, 15.0, vw, false, FindMaskID);
				Attach3DTextLabelToPlayer(Text3D:textLabelID[playerid], playerid, 0.0, 0.0, 0.7);
				
				for (new i = 0; i < MAX_PLAYERS; i++)
			    {
			        ShowPlayerNameTagForPlayer(i, playerid, false);
			    }
			}
			else if(HasPlayerUsedMask[playerid] > 0)
			{
				HasPlayerUsedMask[playerid] = 0;
				Delete3DTextLabel(Text3D:textLabelID[playerid]);
				
				for (new i = 0; i < MAX_PLAYERS; i++)
			    {
			        ShowPlayerNameTagForPlayer(i, playerid, true);
			    }
			}
		}
    }
    return 1;
}

CMD:getlicense(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1376.2294,-1423.9144,13.5768))
    	{
        	ShowPlayerDialog(playerid, DIALOG_LICENSE_VIEW, DIALOG_STYLE_LIST, "License School - Options", "1. Motorcycle License ($240)\n2. Car License ($500)\n3. Truck License ($1,000)", "Start", "Close");
     	}
        else return SendPlayerErrorMessage(playerid, " You are not near the license school help desk!");
	}
	return 1;
}

CMD:licenses(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new string[256], string1[256], string2[256], string3[256], string4[256], string5[256], string6[256], string7[256];
	    new L1[30], L2[30], L3[30], L4[30], L5[30], L6[30];
	
	    if(PlayerData[playerid][Character_License_Car] == 1) { format(L1, sizeof(L1), "{99D87D}Issued"); }
   		else if(PlayerData[playerid][Character_License_Car] == 0) { format(L1, sizeof(L1), "{F08080}Not Obtained"); }

        if(PlayerData[playerid][Character_License_Truck] == 1) { format(L2, sizeof(L2), "{99D87D}Issued"); }
        else if(PlayerData[playerid][Character_License_Truck] == 0) { format(L2, sizeof(L2), "{F08080}Not Obtained"); }

        if(PlayerData[playerid][Character_License_Motorcycle] == 1) { format(L3, sizeof(L3), "{99D87D}Issued"); }
        else if(PlayerData[playerid][Character_License_Motorcycle] == 0) { format(L3, sizeof(L3), "{F08080}Not Obtained"); }

        if(PlayerData[playerid][Character_License_Boat] == 1) { format(L4, sizeof(L4), "{99D87D}Issued"); }
        else if(PlayerData[playerid][Character_License_Boat] == 0) { format(L4, sizeof(L4), "{F08080}Not Obtained"); }

        if(PlayerData[playerid][Character_License_Flying] == 1) { format(L5, sizeof(L5), "{99D87D}Issued"); }
        else if(PlayerData[playerid][Character_License_Flying] == 0) { format(L5, sizeof(L5), "{F08080}Not Obtained"); }

        if(PlayerData[playerid][Character_License_Firearms] == 1) { format(L6, sizeof(L6), "{99D87D}Issued"); }
        else if(PlayerData[playerid][Character_License_Firearms] == 0) { format(L6, sizeof(L6), "{F08080}Not Obtained"); }

  		format(string, sizeof(string), "> %s has removed their ID from their pocket and looks at it", GetName(playerid));
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

		format(string1, sizeof(string1), "*** {F2F746}Your Licenses{FFFFFF} ***");
		SendClientMessage(playerid, COLOR_WHITE, string1);

		format(string2, sizeof(string2), "> Car License:{FFFFFF} %s", L1);
		SendClientMessage(playerid, COLOR_WHITE, string2);
		format(string3, sizeof(string3), "> Truck License:{FFFFFF} %s", L2);
		SendClientMessage(playerid, COLOR_WHITE, string3);
		format(string4, sizeof(string4), "> Motorcycle License:{FFFFFF} %s", L3);
		SendClientMessage(playerid, COLOR_WHITE, string4);
		format(string5, sizeof(string5), "> Boat License:{FFFFFF} %s", L4);
		SendClientMessage(playerid, COLOR_WHITE, string5);
		format(string6, sizeof(string6), "> Pilot License:{FFFFFF} %s", L5);
		SendClientMessage(playerid, COLOR_WHITE, string6);
		format(string7, sizeof(string7), "> Weapon License:{FFFFFF} %s", L6);
		SendClientMessage(playerid, COLOR_WHITE, string7);
	}
	return 1;
}

CMD:showlicenses(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid;

		if(sscanf(params, "i", targetid))
		{
			SendPlayerServerMessage(playerid, " /showlicenses [targetid]");
   		}
		else
		{
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot show your license to yourself with this command! [/licenses]");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
		    new string[256], string1[256], string2[256], string3[256], string4[256], string5[256], string6[256], string7[256];
		    new L1[30], L2[30], L3[30], L4[30], L5[30], L6[30];
		    
		    if(PlayerData[playerid][Character_License_Car] == 1) { format(L1, sizeof(L1), "{99D87D}Issued"); }
	   		else if(PlayerData[playerid][Character_License_Car] == 0) { format(L1, sizeof(L1), "{F08080}Not Obtained"); }
	
	        if(PlayerData[playerid][Character_License_Truck] == 1) { format(L2, sizeof(L2), "{99D87D}Issued"); }
	        else if(PlayerData[playerid][Character_License_Truck] == 0) { format(L2, sizeof(L2), "{F08080}Not Obtained"); }
	
	        if(PlayerData[playerid][Character_License_Motorcycle] == 1) { format(L3, sizeof(L3), "{99D87D}Issued"); }
	        else if(PlayerData[playerid][Character_License_Motorcycle] == 0) { format(L3, sizeof(L3), "{F08080}Not Obtained"); }
	
	        if(PlayerData[playerid][Character_License_Boat] == 1) { format(L4, sizeof(L4), "{99D87D}Issued"); }
	        else if(PlayerData[playerid][Character_License_Boat] == 0) { format(L4, sizeof(L4), "{F08080}Not Obtained"); }
	
	        if(PlayerData[playerid][Character_License_Flying] == 1) { format(L5, sizeof(L5), "{99D87D}Issued"); }
	        else if(PlayerData[playerid][Character_License_Flying] == 0) { format(L5, sizeof(L5), "{F08080}Not Obtained"); }
	
	        if(PlayerData[playerid][Character_License_Firearms] == 1) { format(L6, sizeof(L6), "{99D87D}Issued"); }
	        else if(PlayerData[playerid][Character_License_Firearms] == 0) { format(L6, sizeof(L6), "{F08080}Not Obtained"); }

	  		format(string, sizeof(string), "> %s has removed their ID from their pocket and handed it to %s", GetName(playerid), GetName(targetid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			
			format(string1, sizeof(string1), "*** %s Licenses ***", PlayerData[playerid][Character_Name]);
			SendClientMessage(targetid, COLOR_WHITE, string1);
	
			format(string2, sizeof(string2), "> Car License:{FFFFFF} %s", L1);
			SendClientMessage(targetid, COLOR_WHITE, string2);
			format(string3, sizeof(string3), "> Truck License:{FFFFFF} %s", L2);
			SendClientMessage(targetid, COLOR_WHITE, string3);
			format(string4, sizeof(string4), "> Motorcycle License:{FFFFFF} %s", L3);
			SendClientMessage(targetid, COLOR_WHITE, string4);
			format(string5, sizeof(string5), "> Boat License:{FFFFFF} %s", L4);
			SendClientMessage(targetid, COLOR_WHITE, string5);
			format(string6, sizeof(string6), "> Pilot License:{FFFFFF} %s", L5);
			SendClientMessage(targetid, COLOR_WHITE, string6);
			format(string7, sizeof(string7), "> Weapon License:{FFFFFF} %s", L6);
			SendClientMessage(targetid, COLOR_WHITE, string7);
		}
	}
	return 1;
}

CMD:pockets(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		new string[256];
  		format(string, sizeof(string), "> %s has just searched their pockets", GetName(playerid));
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

        new bodytext[2000];
		format(bodytext, sizeof(bodytext), "Ropes\t%i\nFuel Cans\t%i\nLockpicks\t%i\nDrugs\t%i\nCocaine\t%i\nHeroin\t%i\nFood\t%i\nDrinks\t%i\nAlcohol\t%i\nHacking Devices\t%i", PlayerData[playerid][Character_Has_Rope], PlayerData[playerid][Character_Has_Fuelcan], PlayerData[playerid][Character_Has_Lockpick], PlayerData[playerid][Character_Has_Drugs], PlayerData[playerid][Character_Drug_Cocaine], PlayerData[playerid][Character_Drug_Heroin], PlayerData[playerid][Character_Has_Food], PlayerData[playerid][Character_Has_Drinks], PlayerData[playerid][Character_Has_Alcohol], PlayerData[playerid][Character_Has_Device]);

		ShowPlayerDialog(playerid, DIALOG_PLAYER_POCKETS, DIALOG_STYLE_TABLIST, "Player Pockets", bodytext, "Close", "");
	}
	return 1;
}

CMD:rent(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Hotel_ID] == 0)
        {
            new dstring[250];
            
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 1498.2710,-1581.8063,13.5498))
        	{
        	    if(PlayerData[playerid][Character_Money] >= 250)
        	    {
        	        PlayerData[playerid][Character_Money] += -250;
        	        
	            	PlayerData[playerid][Character_Hotel_ID] = 1;

					PlayerData[playerid][Hotel_Character_Pos_X] = 272.5362;
				    PlayerData[playerid][Hotel_Character_Pos_Y] = 307.3446;
				    PlayerData[playerid][Hotel_Character_Pos_Z] = 999.1484;
				    PlayerData[playerid][Hotel_Character_Pos_Angle] = 0;

					PlayerData[playerid][Hotel_Character_Interior_ID] = 2;
				    PlayerData[playerid][Hotel_Character_Virtual_World] = playerid+1;

				    format(dstring, sizeof(dstring), "> You have just rented a room at the Trump Hotel!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);
					
					new updatequery[2000];
     				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_hotel_id` = '%i', \
																											`hotel_character_pos_x` = '%f', \
																											`hotel_character_pos_y` = '%f', \
																											`hotel_character_pos_z` = '%f', \
																											`hotel_character_pos_angle` = '%f', \
																											`hotel_character_interior_id` = '%i', \
																											`hotel_character_virtual_world` = '%i' WHERE `character_name` = '%e' LIMIT 1" \
																											, PlayerData[playerid][Character_Hotel_ID] \
																											, PlayerData[playerid][Hotel_Character_Pos_X] \
																											, PlayerData[playerid][Hotel_Character_Pos_Y] \
																											, PlayerData[playerid][Hotel_Character_Pos_Z] \
																											, PlayerData[playerid][Hotel_Character_Pos_Angle] \
																											, PlayerData[playerid][Hotel_Character_Interior_ID] \
																											, PlayerData[playerid][Hotel_Character_Virtual_World], GetName(playerid));
				    mysql_tquery(connection, updatequery);
				}
				else return SendPlayerErrorMessage(playerid, " You do not have $250 to rent this property!");
	        }
	        else return SendPlayerErrorMessage(playerid, " You are not at a rental property!");
        }
        else return SendPlayerErrorMessage(playerid, " You already are renting a room somewhere else, try again later!");
    }
	return 1;
}

CMD:unrent(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Hotel_ID] == 1)
        {
            new dstring[250];

            if(IsPlayerInRangeOfPoint(playerid, 3.0, 1498.2710,-1581.8063,13.5498))
        	{
        	    PlayerData[playerid][Character_Money] += 50;

				PlayerData[playerid][Character_Hotel_ID] = 0;

				PlayerData[playerid][Hotel_Character_Pos_X] = 0;
			    PlayerData[playerid][Hotel_Character_Pos_Y] = 0;
			    PlayerData[playerid][Hotel_Character_Pos_Z] = 0;
			    PlayerData[playerid][Hotel_Character_Pos_Angle] = 0;

				PlayerData[playerid][Hotel_Character_Interior_ID] = 0;
			    PlayerData[playerid][Hotel_Character_Virtual_World] = 0;

			    format(dstring, sizeof(dstring), "> You have just unrented a room at the Trump Hotel and received a $50 deposit back!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_hotel_id` = '0', \
																											`hotel_character_pos_x` = '0', \
																											`hotel_character_pos_y` = '0', \
																											`hotel_character_pos_z` = '0', \
																											`hotel_character_pos_angle` = '0', \
																											`hotel_character_interior_id` = '0', \
																											`hotel_character_virtual_world` = '0' WHERE `character_name` = '%e' LIMIT 1", GetName(playerid));
	        }
	        else return SendPlayerErrorMessage(playerid, " You are not at a rental property!");
        }
        else return SendPlayerErrorMessage(playerid, " You cannot unrent a room that you do not have, try again later!");
    }
	return 1;
}


CMD:change(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Skin_1] > 0 || PlayerData[playerid][Character_Skin_2] > 0 || PlayerData[playerid][Character_Skin_3] > 0)
        {
            new option1[256], option2[256], option3[256], options[256];
            
            if(PlayerData[playerid][Character_Skin_1] == 0)
            {
            	format(option1, sizeof(option1), "Outfit 1 - [Nothing Saved]");
			}
			else if(PlayerData[playerid][Character_Skin_1] != 0)
			{
				format(option1, sizeof(option1), "Outfit 1");
			}
			
			if(PlayerData[playerid][Character_Skin_2] == 0)
            {
            	format(option2, sizeof(option2), "Outfit 2 - [Nothing Saved]");
			}
			else if(PlayerData[playerid][Character_Skin_2] != 0)
			{
				format(option2, sizeof(option2), "Outfit 2");
			}
			
			if(PlayerData[playerid][Character_Skin_3] == 0)
            {
            	format(option3, sizeof(option3), "Outfit 3 - [Nothing Saved]");
			}
			else if(PlayerData[playerid][Character_Skin_3] != 0)
			{
				format(option3, sizeof(option3), "Outfit 3");
			}
			
			format(options, sizeof(options), "%s\n%s\n%s", option1, option2, option3);
			
			ShowPlayerDialog(playerid, DIALOG_PLAYER_SKINS, DIALOG_STYLE_LIST, "Clothing Selection Menu", options, "Change", "Close");
        }
        else return SendPlayerErrorMessage(playerid, " You have not purchased any skins for this Character!");
    }
	return 1;
}

CMD:mobilecommands(playerid, params[]) return cmd_mcmds(playerid, params);
CMD:mcmds(playerid, params[])
{
	new type[50];
	
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(sscanf(params, "s[50]", type))
	    {
			SendPlayerServerMessage(playerid, " /mcmds [type]");
			SendPlayerServerMessage(playerid, " Types: Generic, Faction, House, Business, Job, Staff");
		}
		else
		{
			if(strcmp(type, "generic", false) == 0)
			{
				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Generic Commands ***");
				SendClientMessage(playerid, COLOR_YELLOW, "Account:{FFFFFF} /unstuck /changepassword /paymenttype");
      			SendClientMessage(playerid, COLOR_YELLOW, "Community:{FFFFFF} /staff /helpme /assistance /report /commands /guide /time");
				SendClientMessage(playerid, COLOR_YELLOW, "Chat:{FFFFFF} /w(hisper) /s(hout) /o(oc) /g(lobal) /clearchat /radio(r) /pm");
				SendClientMessage(playerid, COLOR_YELLOW, "Phone:{FFFFFF} /phonebook /phonenumber /togglephone /call /pickup /endcall /gps /cancelgps");
				SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /me /do /acceptdeath /stats /pay /paybill /bills /billcustomer /acceptdeath /shop");
				SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /getlicense /licenses /showlicenses /pockets /change /shop /tie");
				SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rappel /hack /rob /hw(hotwire) /gate /bankaccount /smuggle /bake /usedrugs");
				SendClientMessage(playerid, COLOR_YELLOW, "Vehicle:{FFFFFF} /engine /lights /bonnet /boot /rentcar /unrentcar /fillup /recyclecar /changeownership /park /flash");
				SendClientMessage(playerid, COLOR_YELLOW, "Faction:{FFFFFF} /joinfaction /cancelrequest");
				SendClientMessage(playerid, COLOR_YELLOW, "Misc:{FFFFFF} /buyfaction /sellfaction /rent /unrent");
			}
			else if(strcmp(type, "faction", false) == 0)
			{
				if(PlayerData[playerid][Character_Faction] == 0)
				{					
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF} You are currently not apart of any factionin this server!\n\nYou can join a faction by locating the faction [i] icon and typing");
					SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF} /joinfaction or applying through the forums!");
					SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF} We have attempted to keep this server user friendly by allowing ingame and forums faction applications.");
				}
				else if(PlayerData[playerid][Character_Faction] == 1)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSPD)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /search /cancelbackup(cbu) /backup(bu) /mdc /ticket /arrest /placeincar(pic)");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /cuff /taser /acceptjob /canceljob /acceptcall /drag");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSPD)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /search /cancelbackup(cbu) /backup(bu) /mdc /ticket /arrest /placeincar(pic)");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /cuff /taser /acceptjob /canceljob /acceptcall /drag");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest /issuelicense");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 2)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSFD)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /fireex /acceptjob /canceljob /acceptcall");
					}
					else
					{
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSFD)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /fireex /acceptjob /canceljob /acceptcall");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 3)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSMC)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /drag /heal /placeincar(pic)");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LSMC)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /drag /heal /placeincar(pic)");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 4)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LS Bank)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /computer /funds");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (LS Bank)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /computer /funds");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 5)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
					    SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Tow Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Tow Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 6)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Taxi Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Taxi Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 7)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Truck Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Truck Co)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 8)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
					    SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Dudefix)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptjob /canceljob /shovel /fixpipe");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Dudefix)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptjob /canceljob /shovel /fixpipe");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 9)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
					   	SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Mechanic)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /acceptjob /canceljob /tools /checkgear /fix /fillvehicle");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Mechanic)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /duty /joinfaction /quitfaction /gate");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /acceptcall /acceptjob /canceljob /tools /checkgear /fix /fillvehicle");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 10)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Grove Street Gang)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Grove Street Gang)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 11)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (La Familia)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (La Familia)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 12)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hells Angels Gang)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hells Angels Gang)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
				else if(PlayerData[playerid][Character_Faction] == 13)
				{
					if(PlayerData[playerid][Character_Faction_Rank] != 6)
					{
		        		SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hendrix Crime Familia)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
					}
					else
					{						
						SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Faction Commands (Hendrix Crime Familia)***");
						SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /fradio(fr) /factionchat(fc) /fstaff /joinfaction /quitfaction");
						SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /rob /hw(hotwire) /hack");
						SendClientMessage(playerid, COLOR_YELLOW, "Leader:{FFFFFF} /hire /fire /setrank /requests /acceptrequest /rejectrequest");
					}
				}
			}
			else if(strcmp(type, "house", false) == 0)
			{
				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay House Commands ***");
				SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /buyproperty /sellproperty");
			}
			else if(strcmp(type, "business", false) == 0)
			{
				SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Business Commands ***");
				SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /buybusiness /sellbusiness");
			}
			else if(strcmp(type, "job", false) == 0)
			{
				if(PlayerData[playerid][Character_Job] == 1)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Pizza Delivery)***");
					SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
					SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
				}
				else if(PlayerData[playerid][Character_Job] == 2)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Garbage Collector)***");
					SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
					SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob");
				}
				else if(PlayerData[playerid][Character_Job] == 3)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Job Commands (Electrician)***");
					SendClientMessage(playerid, COLOR_YELLOW, "Basic:{FFFFFF} /joinjob /quitjob");
					SendClientMessage(playerid, COLOR_YELLOW, "General:{FFFFFF} /startjob /stopjob /flash");
				}
				else return SendPlayerErrorMessage(playerid, " You are not apart of any job company at this point in time!");
			}
			else if(strcmp(type, "staff", false) == 0)
			{
				if(PlayerData[playerid][Helper_Level] == 1)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
				}
				else if(PlayerData[playerid][Moderator_Level] == 1)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
				}
				else if(PlayerData[playerid][Admin_Level] == 1)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
				}
				else if(PlayerData[playerid][Admin_Level] == 2)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /unmute /mute /sethealth");
				}
				else if(PlayerData[playerid][Admin_Level] == 3)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /unmute /mute /sethealth");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
				}
				else if(PlayerData[playerid][Admin_Level] == 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /unmute /mute /sethealth");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
				}
				else if(PlayerData[playerid][Admin_Level] == 5)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /unmute /mute /sethealth");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /giveweapon /starttornado /stoptornado /givecoins");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /vinfo /vdelete /vcreate /vpark /vremoveowner /vsetowner /vremovefaction /vsetfaction /vsetjob /vtype");
				}
				else if(PlayerData[playerid][Admin_Level] == 6)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Staff Commands ***");
					SendClientMessage(playerid, COLOR_YELLOW, "Helper:{FFFFFF} /helperchat(h) /helpmetoggle /spectate /endspectate /nudge /slap");
					SendClientMessage(playerid, COLOR_YELLOW, "Moderator:{FFFFFF} /moderatorchat(m) /kick /reports /closereport /gotocar /gotodoor /gotobiz /gotohouse /jetpack /getplayer /gotoplayer");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 1:{FFFFFF} /adminchat(a) /gotols /gotopos /ajail /rajail /ban /offlineban /unban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 2:{FFFFFF} /getcar /unmute /mute /sethealth");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 3:{FFFFFF} /avrespawn /avrefill /setskin /setarmour");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 4:{FFFFFF} /setlicense /givephone /givemoney /weaponban /rweaponban /factionban /rfactionban");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /giveweapon /starttornado /stoptornado /givecoins");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 5:{FFFFFF} /vinfo /vdelete /vcreate /vpark /vremoveowner /vsetowner /vremovefaction /vsetfaction /vsetjob /vtype");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /fnext /finfo /ficonpos /fsetcost /fsettype /fsetowner /fremoveowner /fname /frankname /fdelete");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /ddnext /ddinfo /ddname /ddfaction //ddedit /dddelete");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /hnext /hinfo /hedit /hpreset /hdelete /hsetaddress /hsetcost /hsetowner /hremoveowner");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /bnext /binfo /bedit /bdelete /bsetname /bsetcost /bsettype /bsetowner /bremoveowner");
					SendClientMessage(playerid, COLOR_YELLOW, "Admin Level 6:{FFFFFF} /setleader /sethelper /setmoderator /setadmin /gmx /givecoins /globalchat");
				}
			}
		}
	}
	return 1;
}

CMD:commands(playerid, params[]) return cmd_cmds(playerid, params);
CMD:cmds(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
			ShowPlayerDialog(playerid, DIALOG_COMMANDS_MAIN, DIALOG_STYLE_LIST, "Open Roleplay - Commands Menu", "Generic Commands\nFaction Commands\nHouse Commands\nBusiness Commands\nJob Commands\nStaff Commands", "Select", "Close");
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:animations(playerid, params[]) return cmd_anims(playerid, params);
CMD:anims(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
			SendClientMessage(playerid, COLOR_YELLOW, "*** Open Roleplay Animations ***");
      		SendClientMessage(playerid, COLOR_WHITE, "/stopanim /bodypush /lowbodypush /headbutt /airkick /doorkick /leftslap /elbow /coprun");
			SendClientMessage(playerid, COLOR_WHITE, "/handsup /piss /sneak /drunk /bomb /robbing /laugh /lookout /robman /hide /vomit /eat /slapass");
			SendClientMessage(playerid, COLOR_WHITE, "/fuckyou /sleep /wavedown /cpr /throw /robbed /hurt /fallover /smoke /crossarms /sit /dance");
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:assistance(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(HasPlayerRequestAssistance[playerid] == 1) return SendPlayerErrorMessage(playerid, " You have already sent a request through to the staff team, please wait!"); 
	    if(IsPlayerLogged[playerid])
	    {
			HasPlayerRequestAssistance[playerid] = 1;			
			
	        new string[256];

			SendPlayerServerMessage(playerid, " You have just requested for an admins assistance, please wait!");

	        format(string, sizeof(string), "[ASSISTANCE REQUIRED]:{FFFFFF} %s has requested assistance at their current spot [Player ID: %d]", GetName(playerid), playerid);
			SendAdminMessage(COLOR_AQUABLUE, string);
			
			Assistance_Timer[playerid] = SetTimerEx("AssistanceTimer", 60000, false, "i", playerid);
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid, reason[256];

		if(sscanf(params, "is[256]", targetid, reason))
		{
			SendPlayerServerMessage(playerid, " /report [targetid] [reason]");
   		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot report yourself. Use /helpme for further assistance!"); 
			
		    new query[2000];
   			mysql_format(connection, query, sizeof(query), "INSERT INTO `report_information` (`character_name`, `target_name`, `reason`) VALUES ('%e', '%e','%s')", PlayerData[playerid][Character_Name], PlayerData[targetid][Character_Name], reason);
			mysql_tquery(connection, query);

		    new dstring[500];
			format(dstring, sizeof(dstring), "> You have just reported %s for '%s'", GetName(targetid), reason);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			new string[500];
			format(string, sizeof(string), "[NEW REPORT]:{FFFFFF} %s has just reported %s for %s", GetName(playerid), GetName(targetid), reason);
			SendReportMessage(COLOR_AQUABLUE, string);
		}
	}
	return 1;
}

CMD:staff(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
	        new atext[50], string[256];
	        
			SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Online Community Staff{FFFFFF} ***");
			
	        for (new i = 0; i < MAX_PLAYERS; i++)
	        {
				if(PlayerData[i][Helper_Level] > 0)
				{
		            format(string, sizeof(string), "> {F2F746}[Helper]{FFFFFF} %s", PlayerData[i][Character_Name]);
		            SendClientMessage(playerid, COLOR_WHITE, string);
				}
				
				if(PlayerData[i][Moderator_Level] > 0)
				{
		            format(string, sizeof(string), "> {F2F746}[Moderator]{FFFFFF} %s", PlayerData[i][Character_Name]);
		            SendClientMessage(playerid, COLOR_WHITE, string);
				}
				
				if(PlayerData[i][Admin_Level] > 0)
				{
					switch(PlayerData[i][Admin_Level])
					{
					    case 1: { atext = "[Admin - L1]"; }
					    case 2: { atext = "[Admin - L2]"; }
					    case 3: { atext = "[Admin - L3]"; }
					    case 4: { atext = "[Senior Admin]"; }
					    case 5: { atext = "[Management]"; }
					    case 6: { atext = "[Owner]"; }
					}

		            format(string, sizeof(string), "> {F2F746}%s{FFFFFF} %s", atext, PlayerData[i][Character_Name]);
		            SendClientMessage(playerid, COLOR_WHITE, string);
				}
	        }
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:guide(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 3.0, -1876.2999,50.1774,1055.1891))
	        {
	            ShowPlayerDialog(playerid, DIALOG_GUIDE_LIST, DIALOG_STYLE_LIST, "Open Roleplay - Entry Guide", "Quick Job Information\nQuick Faction Information\nQuick Command Information\nQuick Vehicle Information\nQuick House Information\nQuick Admin Information", "Select", "Close");
	        }
	        else return SendPlayerErrorMessage(playerid, " You are not near the /guide command help desk [Located within Airport Terminal]!");
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:time(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        new dstring[256];
			if(IsPlayerInHospital[playerid] == 1)
			{
				format(dstring, sizeof(dstring), "[TIMER]:{FFFFFF} You have less that one minute remaining in the hospital!");
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
			}
	        else if(PlayerData[playerid][Admin_Jail] == 1 && PlayerData[playerid][Character_Jail] == 0)
	        {
	            format(dstring, sizeof(dstring), "[TIMER]:{FFFFFF} You have %i minutes left in your sentence within the admin jail!", PlayerData[playerid][Admin_Jail_Time]);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
	        }
	        else if(PlayerData[playerid][Character_Jail] == 1 && PlayerData[playerid][Admin_Jail] == 0)
	        {
	            format(dstring, sizeof(dstring), "[TIMER]:{FFFFFF} You have %i minutes left in your sentence within the prison!", PlayerData[playerid][Character_Jail_Time]);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
	        }
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:rentcar(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        new dstring[256];

			if(IsPlayerInRangeOfPoint(playerid, 5.0,1418.2869,-2312.1880,13.9298))
			{
		        if(IsPlayerRentingCar[playerid] == 1)
		        {
		            SendPlayerErrorMessage(playerid, " You are already renting a vehicle, you need to use /unrentcar before you can use this again!");

		            printf("%s has tried to rent a vehicle while already renting a vehicle - denied access", GetName(playerid));
		        }
		        else if(IsPlayerRentingCar[playerid] == 0)
		        {
		            IsPlayerRentingCar[playerid] = 1;

		            PlayerData[playerid][Character_Money] -= 250;

					format(dstring, sizeof(dstring), "[RENTAL YARD]:{FFFFFF} Please pick a vehicle of your liking and have an awesome day!");
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
					format(dstring, sizeof(dstring), "> You have just paid $250.00 to rent a vehicle from the airport terminal");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					printf("%s has just rented a vehicle", GetName(playerid));
		        }
			}
			else return SendPlayerErrorMessage(playerid, " You are not near the vehicle rental place!");
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:unrentcar(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        new dstring[256];

	        if(IsPlayerRentingCar[playerid] == 0)
	        {
	            SendPlayerErrorMessage(playerid, " You are currently not renting any vehicles!");
	            
	            printf("%s has tried to unrent a vehicle they do not have - access denied", GetName(playerid));
	        }
	        else if(IsPlayerRentingCar[playerid] == 1)
	        {
	            IsPlayerRentingCar[playerid] = 0;
	            
	            PlayerData[playerid][Character_Money] += 100;

				format(dstring, sizeof(dstring), "> You have just been given $100 for returning the vehicle!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("%s has returned a rental vehicle and received money", GetName(playerid));
	        }
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
    if(IsPlayerInjured[playerid] == 0) return SendPlayerErrorMessage(playerid, " You cannot accept death when you are not low on health!");
    if(PlayerData[playerid][Admin_Jail] == 1) return SendPlayerErrorMessage(playerid, " You cannot accept death while you are in admin jail!");
    else
	{
		SetPlayerHealth(playerid, 0);
	}
	return 1;
}

CMD:stats(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        new titlestring[100], dialogstring[2000], staffname[50];
			new fstring[20], frankstring[20], jstring[50];
			new factionid;
	
			if(PlayerData[playerid][Helper_Level] == 1) { format(staffname, sizeof(staffname), "Helper"); }
			else if(PlayerData[playerid][Moderator_Level] == 1) { format(staffname, sizeof(staffname), "Moderator"); }
			else if(PlayerData[playerid][Admin_Level] == 1) { format(staffname, sizeof(staffname), "Admin - Level 1"); }
			else if(PlayerData[playerid][Admin_Level] == 2) { format(staffname, sizeof(staffname), "Admin - Level 2"); }
			else if(PlayerData[playerid][Admin_Level] == 3) { format(staffname, sizeof(staffname), "Admin - Level 3"); }
			else if(PlayerData[playerid][Admin_Level] == 4) { format(staffname, sizeof(staffname), "Admin - Level 4"); }
			else if(PlayerData[playerid][Admin_Level] == 5) { format(staffname, sizeof(staffname), "Admin - Level 5"); }
			else if(PlayerData[playerid][Admin_Level] == 6) { format(staffname, sizeof(staffname), "Admin - Level 6"); }

			factionid = PlayerData[playerid][Character_Faction];

			if(PlayerData[playerid][Character_Faction] == 0)
			{
				fstring = "None";
			}
			else
			{
				format(fstring, sizeof(fstring), "%s", FactionData[factionid][Faction_Name]);
			}

			switch(PlayerData[playerid][Character_Faction_Rank])
			{
				case 0: { format(frankstring, sizeof(frankstring), "None"); }
				case 1: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_1]); }
				case 2: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_2]); }
				case 3: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_3]); }
				case 4: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_4]); }
				case 5: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_5]); }
				case 6: { format(frankstring, sizeof(frankstring), "%s", FactionData[factionid][Faction_Rank_6]); }
			}
				
			switch(PlayerData[playerid][Character_Job])
			{
				case 0: { format(jstring, sizeof(jstring), "None"); }
				case 1: { format(jstring, sizeof(jstring), "Pizza Delivery"); }
				case 2: { format(jstring, sizeof(jstring), "Garbage Collector"); }
				case 3: { format(jstring, sizeof(jstring), "Electrician"); }
			}
	        
	        format(titlestring, sizeof(titlestring), "%s Statistics (In-Game)", GetName(playerid));
			format(dialogstring, sizeof(dialogstring), " Character Name: \t%s\n Character Age: \t%i\n Character Sex: \t%s\n Character Birthplace: \t%s\n\n Character Level: \t%i\n Character Exp: \t%i/8\n Staff Level: \t%s\n Faction: \t%s\n Faction Rank: \t%s\n Job: \t%s", PlayerData[playerid][Character_Name], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace],PlayerData[playerid][Character_Level] , PlayerData[playerid][Character_Level_Exp], staffname, fstring, frankstring, jstring);
	        ShowPlayerDialog(playerid, DIALOG_PLAYER_STATS, DIALOG_STYLE_TABLIST, titlestring, dialogstring, "More", "Close");
	    }
	}
	return 1;
}

CMD:shop(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new shopid;

		if(!IsPlayerNearBusinessShopPoint(playerid) || PlayerAtBusinessBuyPointID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a purchase point!");
		else
		{
		    shopid = PlayerAtBusinessBuyPointID[playerid];

			if(BusinessData[shopid][Business_Type] == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_ONE, DIALOG_STYLE_LIST, "24/7 Convenience Store", "Hotdog\nSoda\nSpirits\nLockpick\nRope\nMask", "Purchase", "Close");
    		}
			else if(BusinessData[shopid][Business_Type] == 2)
			{
				ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_TWO, DIALOG_STYLE_LIST, "Supermarket Store", "Fruit\nVegetables\nDrinks\nMilk\nCheese\nMetal Fragments\nMeat", "Purchase", "Close");
    		}
			else if(BusinessData[shopid][Business_Type] == 3)
			{
		 		ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_THREE, DIALOG_STYLE_LIST, "Electronic Store", "Mobile Phone\nSim Card\nHouse Items", "Next", "Close");
	    	}
			else if(BusinessData[shopid][Business_Type] == 4)
			{
		 		ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FOUR, DIALOG_STYLE_LIST, "Fast Food Joint", "Number 1 ($10)\nNumber 2 ($15)\nNumber 3 ($50)\nNumber 4 ($65)\nFat Guy ($150)", "Purchase", "Close");
	    	}
			else if(BusinessData[shopid][Business_Type] == 5)
			{
		 		ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_FIVE, DIALOG_STYLE_LIST, "Bar / Resturant", "Vodka ($10)\nRose Bud ($15)\nBeer ($20)\nPeanuts ($4)\nCrisps ($6)", "Purchase", "Close");
	    	}
			else if(BusinessData[shopid][Business_Type] == 6)
			{				
		 		new count = 0;

			    for(new i = 0; i < MAX_PLAYERS; i++)
			    {
			        if(IsPlayerConnected(i))
			        {
			            if(IsPlayerInViewState_Binco[i] == 1)
						{
			                count++;
			            }
			        }
			    }
			    if (count > 0)
			    {
			        SendPlayerErrorMessage(playerid, " Someone else is already viewing clothing, please wait!");
			    }
				else
				{
					Binco_Current_Outfit[playerid] = GetPlayerSkin(playerid);
					Binco_Current_VW[playerid] = GetPlayerVirtualWorld(playerid);
					
					IsPlayerInViewState_Binco[playerid] = 1;
					
					SetPlayerPos(playerid, 217.3819,-98.1815,1005.2578);
					SetPlayerCameraPos(playerid, 213.1676,-101.4018,1006.3436);
					SetPlayerCameraLookAt(playerid, 217.3819,-98.1815,1005.2578);
					SetPlayerFacingAngle(playerid, 127.9192);
					SetPlayerVirtualWorld(playerid, 200);
					
					TogglePlayerControllable(playerid,false);
					
					new tdstring1[500];
					format(tdstring1, sizeof(tdstring1), "Welcome to the ~y~Binco Clothing Store~w~~n~~n~Press ~g~Jump~w~ To Change Skins~n~~n~Press ~g~Fire~w~ To Confirm~n~~n~Press ~r~Aim~w~ To Leave");
					PlayerTextDrawSetString(playerid, PlayerText:Store_Textdraw, tdstring1);
					PlayerTextDrawShow(playerid, PlayerText:Store_Textdraw);
				}		
	    	}
	    	else if(BusinessData[shopid][Business_Type] == 7)
			{
		 		ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_SEVEN, DIALOG_STYLE_LIST, "Ammunation Store", "Weapons\nExtras", "Next", "Close");
	    	}
			else if(BusinessData[shopid][Business_Type] == 8)
			{
		 		ShowPlayerDialog(playerid, DIALOG_SHOP_TYPE_EIGHT, DIALOG_STYLE_LIST, "Donut Shop", "Sprinkles ($10)\nStuffed ($15)\nMystery Filled ($25)", "Purchase", "Close");
	    	}
	    	else if(BusinessData[shopid][Business_Type] == 10)
	    	{
	    	    if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;

                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
	    	    else
	    	    {
	    	        if(VEHICLEPROCESS == 0)
					{
		    	        HasPlayerConfirmedVehicleID[playerid] = 0;
			    	    VEHICLEPROCESS = 1;
						DealershipType[playerid] = 1;

			    	    ClearMessages(playerid);

						SetPlayerCameraPos(playerid, -2026.3075,-116.8879,1035.6638);
						SetPlayerCameraLookAt(playerid, -2021.6074,-116.6880,1036.2498);

			    	    new title[256];
			    	    format(title, sizeof(title), "Vehicle Options");
			    	    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_1_MAIN, DIALOG_STYLE_TABLIST, title, "Hermes \t$25,000\nFortune \t$35,000\nEuros \t$45,000\nClub \t$45,000\nHustler \t$65,000\nWashington \t$80,000\nHuntley \t$90,000", "Select", "Close");
					}
					else
					{
					    SendPlayerErrorMessage(playerid, " Someone is already in the process of purchasing a vehicle from a dealership, please wait!");
					}
				}
			}
			else if(BusinessData[shopid][Business_Type] == 11)
	    	{
	    	    if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;

                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
	    	    else
	    	    {
		    	    if(VEHICLEPROCESS == 0)
		    	    {
		    	        HasPlayerConfirmedVehicleID[playerid] = 0;
			    	    VEHICLEPROCESS = 1;
						DealershipType[playerid] = 2;

			    	    ClearMessages(playerid);

						SetPlayerCameraPos(playerid, -2026.3075,-116.8879,1035.6638);
						SetPlayerCameraLookAt(playerid, -2021.6074,-116.6880,1036.2498);

			    	    new title[256];
			    	    format(title, sizeof(title), "Vehicle Options");
			    	    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_2_MAIN, DIALOG_STYLE_TABLIST, title, "Banshee \t$50,000\nComet \t$52,000\nFlash \t$52,000\nJester \t$55,000\nSuper GT \t$70,000\nTurismo \t$80,000\nInfernus \t$100,000", "Select", "Close");
					}
					else
					{
					    SendPlayerErrorMessage(playerid, " Someone is already in the process of purchasing a vehicle from a dealership, please wait!");
					}
				}
			}
			else if(BusinessData[shopid][Business_Type] == 12)
	    	{
	    	    if(PlayerData[playerid][Character_Total_Vehicles] == 2)
		        {
		            SetCameraBehindPlayer(playerid);

                    VehicleModelPurchasing[playerid] = 0;
                	VEHICLEPROCESS = 0;

                	SendPlayerErrorMessage(playerid, " You cannot own more than two vehicles, please go recycle or sell one if you need to purchase a new one!");
		        }
	    	    else
	    	    {
		    	    if(VEHICLEPROCESS == 0)
		    	    {
		    	        HasPlayerConfirmedVehicleID[playerid] = 0;
			    	    VEHICLEPROCESS = 1;
						DealershipType[playerid] = 3;

			    	    ClearMessages(playerid);

						SetPlayerCameraPos(playerid, -2026.3075,-116.8879,1035.6638);
						SetPlayerCameraLookAt(playerid, -2021.6074,-116.6880,1036.2498);

			    	    new title[256];
			    	    format(title, sizeof(title), "Bike Options");
			    	    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_3_MAIN, DIALOG_STYLE_TABLIST, title, "Faggio \t$5,000\nSanchez \t$7,000\nBF-400 \t$12,000\nPCJ-600 \t$15,000\nNRG-500 \t$50,000", "Select", "Close");
					}
					else
					{
					    SendPlayerErrorMessage(playerid, " Someone is already in the process of purchasing a vehicle from a dealership, please wait!");
					}
				}
			}
			PlayerAtBusinessBuyPointID[playerid] = 0;
		}
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid, money;

	    if(sscanf(params, "ii", targetid, money))
	    {
	        SendPlayerServerMessage(playerid, " /pay [targetid] [amount]");
	    }
	    else
	    {
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot pay yourself money!");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(money > PlayerData[playerid][Character_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money to give this player!");
			if(money < PlayerData[playerid][Character_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money to give this player!");
			else
			{
		        PlayerData[playerid][Character_Money] -= money;
		        PlayerData[targetid][Character_Money] += money;

		        new dstring[256];
				format(dstring, sizeof(dstring), "> You have just been given $%i, by %s!", money, GetName(playerid));
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have just given %s $%i!", GetName(targetid), money);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				format(dstring, sizeof(dstring), "> %s has removed their wallet and given %s some money", GetName(playerid), GetName(targetid));
				SendNearbyMessage(playerid,30.0, COLOR_PURPLE, dstring);
			}
	    }
	}
	return 1;
}

CMD:usedrugs(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		new drugtype;
		
        if(sscanf(params, "i", drugtype))
        {
		    SendPlayerServerMessage(playerid, " /usedrugs [1 - Cocaine | 2 - Heroin]");
		}
		else
		{
			if(drugtype == 1 && PlayerData[playerid][Character_Drug_Cocaine] > 0)
			{
				PlayerData[playerid][Character_Drug_Cocaine] -= 1;
						
				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_drug_cocaine` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Drug_Cocaine], GetName(playerid));
				mysql_tquery(connection, updatequery);
							
				new string[256];
				format(string, sizeof(string), "> %s has just put an item on a spoon and smoked it", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				
				ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, false, false, false, false, 0, SYNC_ALL);
				
				SetPlayerDrunkLevel(playerid, 50000);
				SetPlayerWeather(playerid, 234);
			
				new Float:health;
				GetPlayerHealth(playerid, health);
				health = health + 50;
				SetPlayerHealth(playerid, health);
				
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.0, false, false, false, false, 0, SYNC_ALL);
				
				DrugUseCooldown_Timer[playerid] = SetTimerEx("DrugUseCooldown", 60000, false, "i", playerid);
			}
			else if(drugtype == 2 && PlayerData[playerid][Character_Drug_Heroin] > 0)
			{
				PlayerData[playerid][Character_Drug_Heroin] -= 1;
						
				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_drug_heroin` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Drug_Heroin], GetName(playerid));
				mysql_tquery(connection, updatequery);
							
				new string[256];
				format(string, sizeof(string), "> %s has just injected themselves", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				
				ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, false, false, false, false, 0, SYNC_ALL);
				
				SetPlayerDrunkLevel(playerid, 50000);
				SetPlayerWeather(playerid, 188);
				
				new Float:armour;
				GetPlayerArmour(playerid, armour);
				armour = armour + 40;
				SetPlayerArmour(playerid, armour);
				
				ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.0, true, false, false, false, 0, SYNC_ALL);
				
				DrugUseCooldown_Timer[playerid] = SetTimerEx("DrugUseCooldown", 135000, false, "i", playerid);
			}
			else return SendPlayerErrorMessage(playerid, " You do not have enough of this drug to use!");
        }
	}
	return 1;
}

CMD:bake(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1115.8197,-316.7228,73.9955))
		{
			if(PlayerData[playerid][Character_Has_Drugs] > 0 && HasPlayerBakedDrugs[playerid] == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_DRUG_SELECTION, DIALOG_STYLE_LIST, "Shack House Kitchen", "Cocaine\nHeorin", "Bake", "Close");
			}
			else
			{
				SendPlayerErrorMessage(playerid, " You either do not have any drug materials left or have baked some other drugs recently!");
			}
		}
		else return SendPlayerErrorMessage(playerid, " You are currently not inside the crack house, you cannot start cooking yet!");
	}
	return 1;
}

CMD:smuggle(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		new Float:tx, Float:ty, Float:tz;
		GetActorPos(DrugActor, tx, ty, tz);

		if(IsPlayerInRangeOfPoint(playerid, 3.0, tx, ty, tz))
		{
			if(DrugActorAmountHeld > 0)
			{
				if(HasPlayerTakenDrugs[playerid] == 1) return SendPlayerErrorMessage(playerid, " You have already purchased some drugs recently, please wait a while!");
				else
				{
					new string[256], string1[256], string2[256];
					format(string, sizeof(string), "> Crack Dealer removes a small pouch from their pocket and passes it to %s", GetName(playerid));
					SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, string);
					
					format(string1, sizeof(string1), "Crack Dealer says: Take this and leave me alone");
					SendNearbyMessage(playerid, 15.0, COLOR_WHITE, string1);
					
					DrugActorAmountHeld -= 20;
					HasPlayerTakenDrugs[playerid] = 1;
					PlayerData[playerid][Character_Has_Drugs] += 10;
					
					new updatequery[2000];
					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_has_drugs` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Has_Drugs], GetName(playerid));
				    mysql_tquery(connection, updatequery);
				
					format(string2, sizeof(string2), "> You have just taken some drugs from a drug dealer, go to the shack to pick your poison! [/bake]");
					SendClientMessage(playerid, COLOR_YELLOW, string2);
					
					CrackDealer_Timer[playerid] = SetTimerEx("CrackDealerCooldownTimer", 60000, false, "i", playerid);
				}
			}
			else
			{
				new string[256], string1[256];
				format(string, sizeof(string), "> Crack Dealer attempts to locate drugs on his body");
				SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, string);
				
				format(string1, sizeof(string1), "Crack Dealer says: Sorry mate, but it seems I am all out");
				SendNearbyMessage(playerid, 15.0, COLOR_WHITE, string1);
			}
		}
		else return SendPlayerErrorMessage(playerid, " You are not near a local mystery drug dealer!");
	}
	return 1;
}

CMD:tie(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		new targetid;

        if(PlayerData[playerid][Character_Has_Rope] >= 1)
        {
            if(sscanf(params, "i", targetid))
            {
		    	SendPlayerServerMessage(playerid, " /tie [targetid]");
			}
			else
			{
			    if(targetid == playerid)return SendPlayerErrorMessage(playerid, " You cannot tie up yourself!");
				if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
				else
		  		{
		  		    new Float:tx, Float:ty, Float:tz;
		  		    GetPlayerPos(targetid, tx, ty, tz);

		  		    if(IsPlayerInRangeOfPoint(playerid, 5.0, tx, ty, tz))
		  		    {
		  		        if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_CUFFED)
		  		        {
		  		            IsPlayerTied[targetid] = 0;

			    		    GameTextForPlayer(targetid, "Untied", 2000, 6);

			    		    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
							RemovePlayerAttachedObject(targetid, 0);

			    		    new tdstring1[500];
					    	format(tdstring1, sizeof(tdstring1), "You have been untied. You can now walk around freely!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);
		  		        }
		  		        else
		  		        {
			  		        IsPlayerTied[targetid] = 1;

			    		    GameTextForPlayer(targetid, "Tied Up", 2000, 6);

			    		    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
							SetPlayerAttachedObject(targetid, 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);

			    		    new tdstring2[500];
					    	format(tdstring2, sizeof(tdstring2), "You have been tied up, please wait for further roleplay instructions!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring2);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);
						}
		  		    }
		  		    else return SendPlayerErrorMessage(playerid, " You cannot tie someone up who isn't within the reachable vacinity of you!");
		  		}
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:phonenumber(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 1)
	{
	    if(PlayerData[playerid][Character_Registered] == 1)
	    {
	        new dstring[256];

            if(PlayerData[playerid][Character_Has_Phone] == 0) return SendPlayerErrorMessage(playerid, " You do not have a mobile phone!");
	        else if(PlayerData[playerid][Character_Has_Phone] == 1 && PlayerData[playerid][Character_Phonenumber] == 0)
	        {
	            SendPlayerErrorMessage(playerid, " You do not have an assigned phone number!");
	        }
	        else
			{
			    format(dstring, sizeof(dstring), "[Phone Number]:{FFFFFF} %d", PlayerData[playerid][Character_Phonenumber]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:togglephone(playerid, params[])
{
    if(PlayerData[playerid][Character_Has_Phone] > 0 && PlayerData[playerid][Character_Phonenumber] > 0)
    {
        new string[256];
        
		if(HasPlayerToggledOffDirectory[playerid] == 1)
		{
		    HasPlayerToggledOffDirectory[playerid] = 0;
		    
		    format(string, sizeof(string), "[PHONE UPDATE]:{FFFFFF} You have just enabled your phone for public searching!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else if(HasPlayerToggledOffDirectory[playerid] == 0)
		{
		    HasPlayerToggledOffDirectory[playerid] = 1;
		    
		    format(string, sizeof(string), "[PHONE UPDATE]:{FFFFFF} You have just disabled your phone for public searching!");
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
	}
	return 1;
}

CMD:phonebook(playerid, params[])
{
    if(PlayerData[playerid][Character_Has_Phone] > 0)
    {
	    new dialogText[1024];
	    new count = 0;

	    for (new i = 0; i < MAX_PLAYERS; i++)
	    {
	        if (IsPlayerConnected(i))
	        {
	            if (HasPlayerToggledOffDirectory[i] == 0)
				{
	                format(dialogText, sizeof(dialogText), "%d. Name: %s | Phone Number: %i\n", count + 1, PlayerData[i][Character_Name], PlayerData[i][Character_Phonenumber]);
	                count++;
	            }
	        }
	    }
	    if (count > 0)
	    {
	        ShowPlayerDialog(playerid, DIALOG_PHONEBOOK_NUMBERS, DIALOG_STYLE_LIST, "Phonebook Directory", dialogText, "Close", "");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_PHONEBOOK_NUMBERS, DIALOG_STYLE_LIST, "Phonebook Directory", "There are no active phones online!", "Close", "");
	    }
	}
    else return SendPlayerErrorMessage(playerid, " You do not currently have a phone!");
    return 1;
}

CMD:gps(playerid, params[])
{
	if(HasGPSBeenDisabled[playerid] == 1) return SendPlayerErrorMessage(playerid, " You cannot use the GPS menu while on a job");
    if(PlayerData[playerid][Character_Has_Phone] == 0) return SendPlayerErrorMessage(playerid, " You do not currently have a phone to use a GPS application!");
	else
    {
	    ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST, "Mobile GPS Application", "Top Locations\nFaction Locations\nJob Locations", "Next", "Close");
	}
    return 1;
}

CMD:cancelgps(playerid, params[])
{
    if(PlayerData[playerid][Character_Has_Phone] > 0 && GPSOn[playerid] == true)
    {
        GPSOn[playerid] = false;
	    DisablePlayerCheckpoint(playerid);
	    SendClientMessage(playerid, COLOR_YELLOW, "You have just cancelled your gps location setup!");
	}
    else return SendPlayerErrorMessage(playerid, " You do not currently have a phone with a gps location preset!");
    return 1;
}

CMD:rappel(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 2142.9473,1619.6405,1000.9688))
     	{
		    if(PlayerData[playerid][Character_Has_Rope] > 0)
	        {
                new string[256];
				format(string, sizeof(string), "> %s climbed into the vents and used a rope to enter the vault", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

				PlayerData[playerid][Character_Has_Rope] -= 1;
				HasPlayerBrokenIntoBank[playerid] = 1;

				SetPlayerPos(playerid, 2146.0591,1630.5077,993.5761);
			}
			else return SendPlayerErrorMessage(playerid, " You do not have a rope on you at this time!");
        }
        else return SendPlayerErrorMessage(playerid, " You are currently not near a vent location to rappel down!");
	}
	return 1;
}

CMD:hack(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 2142.4463,1626.2913,993.6882))
     	{
		    if(PlayerData[playerid][Character_Has_Device] > 0 && HasPlayerBrokenIntoBank[playerid] == 0)
	        {
                new string[256];
				format(string, sizeof(string), "> %s removes a tablet from their pocket and connects it to the keypad and the door opens", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

				PlayerData[playerid][Character_Has_Device] -= 1;
				HasPlayerBrokenIntoBank[playerid] = 1;
				
				ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.0, false, false, false, false, 0, SYNC_ALL);
				
				MoveDynamicObject(BankDoor, 2145.1274, 1626.2031, 994.2476, 0.05, 0.00000, 0.00000, 270.00000);
	            BankDoorOpen = true;
			}
			else if(PlayerData[playerid][Character_Has_Device] > 0 && HasPlayerBrokenIntoBank[playerid] == 1 && BankDoorOpen == false)
	        {
                new string[256];
				format(string, sizeof(string), "> %s removes a tablet from their pocket and connects it to the keypad and the door opens", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

				PlayerData[playerid][Character_Has_Device] -= 1;
				HasPlayerBrokenIntoBank[playerid] = 1;

				ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.0, false, false, false, false, 0, SYNC_ALL);

				MoveDynamicObject(BankDoor, 2145.1274, 1626.2031, 994.2476, 0.05, 0.00000, 0.00000, 270.00000);
	            BankDoorOpen = true;
			}
			else if(PlayerData[playerid][Character_Has_Device] == 0) return SendPlayerErrorMessage(playerid, " You do not have any hacking devices on you to break into this vault!");
        }
		if(IsPlayerNearHouseDoor(playerid) && PlayerAtHouseID[playerid] != 0)
		{
			new string[256];
			format(string, sizeof(string), "> %s removes a hacking device from their pocket and starts to turn off the alarm", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
				
			PlayerData[playerid][Character_Has_Device] --;
				
			new hdoorid = PlayerAtHouseID[playerid];
			HouseData[hdoorid][House_Alarm_Active] = 0;
				
			new equery[500];
		    mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_alarm_active` = 0 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
			mysql_tquery(connection, equery);
		}
        else return SendPlayerErrorMessage(playerid, " You are not near anything that can be hacked!");
	}
	return 1;
}

CMD:rob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, 2143.9087,1640.0277,993.5761))
     	{
		    if(BankRobberyTimer == 0)
			{
	            if(HasPlayerBrokenIntoBank[playerid] == 1)
	        	{
				   	new string[256];
					format(string, sizeof(string), "> %s has started filling their pockets with money", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					TogglePlayerControllable(playerid, false);

					new dstring[256];
	      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: ALL UNITS, ALL UNITS, BANK ROBBERY IN PROGRESS)");
					SendFactionRadioMessage(1, COLOR_RED, dstring);

					SendClientMessage(playerid, COLOR_YELLOW, "> You have been frozen for one minute while you rob the bank");

					HasPlayerRobbedBank[playerid] = 1;

					BankRobberyTimer = 1;
				}
				else return SendPlayerErrorMessage(playerid, " You haven't broken into the bank yet!");
	        }
	        else return SendPlayerErrorMessage(playerid, " Someone else has robbed this recently, please try again later!");
		}
		if(IsPlayerNearBusinessShopPoint(playerid))
		{
		    new shopid, count, string[256];
		    shopid = PlayerAtBusinessBuyPointID[playerid];

			if(BusinessData[shopid][Business_Type] == 7)
			{
		 		for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(HasPlayerRobbedAmmunation[i] > 0)
					{
					    count ++;
					}
				}
				
				if(count > 0)
				{
				    SendPlayerErrorMessage(playerid, " Someone else has robbed this recently, please try again later!");
				}
				else if(count == 0)
				{
				    HasPlayerRobbedAmmunationPoint[playerid] = 1;
				    HasPlayerRobbedAmmunation[playerid] = 300;
				    
				    format(string, sizeof(string), "- You have started to rob the ammunation, go around and collect the markers! [You have one minute]");
					SendClientMessage(playerid, COLOR_YELLOW, string);
					
					new dstring[256];
	      			format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: ALL UNITS, ALL UNITS, AMMUNATION ROBBERY IN PROGRESS)");
					SendFactionRadioMessage(1, COLOR_RED, dstring);
					
					SetPlayerCheckpoint(playerid, 307.3639, -132.0233, 1004.0625, 2.0);
				}
	    	}
		}
	}
	return 1;
}

CMD:hotwire(playerid, params[]) return cmd_hw(playerid, params);
CMD:hw(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Has_Lockpick] > 0)
        {
            new vid;
			new Float:vPos[3];

			vid = GetClosestVehicle(playerid);
			GetVehiclePos(vid, vPos[0],vPos[1],vPos[2]);

			if(IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]))
            {
                if(VehicleData[vid][Vehicle_Faction] > 0)
                {
                    if(IsPlayerCuffed[playerid] == 1) return SendPlayerErrorMessage(playerid, " You cannot use this command while handcuffed!");

	                IsPlayerStealingCar[playerid] = VehicleData[vid][Vehicle_Faction];
	                IsPlayerStealingCarID[playerid] = vid;
	                
	                new string[256];
					format(string, sizeof(string), "> %s has started to break in and hotwire the vehicle near them", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
					PlayerData[playerid][Character_Has_Lockpick] -= 1;
					
					SendClientMessage(playerid, COLOR_YELLOW, "- You now must wait 20secs before you can use this vehicle!");

					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, true, false, false, false, 0, SYNC_ALL);
					
	                Hotwire_Timer[playerid] = SetTimerEx("HotWireTimer", 20000, false, "i", playerid);
                }
                else if(VehicleData[vid][Vehicle_Faction] == 0)
                {
                    if(IsPlayerCuffed[playerid] == 1) return SendPlayerErrorMessage(playerid, " You cannot use this command while handcuffed!");

	                IsPlayerStealingCar[playerid] = 999;
	                IsPlayerStealingCarID[playerid] = vid;
	                
	                new string[256];
					format(string, sizeof(string), "> %s has started to break in and hotwire the vehicle near them", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
					PlayerData[playerid][Character_Has_Lockpick] -= 1;
					
					SendClientMessage(playerid, COLOR_YELLOW, "- You now must wait 20secs before you can use this vehicle!");

                 	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, true, false, false, false, 0, SYNC_ALL);

	                Hotwire_Timer[playerid] = SetTimerEx("HotWireTimer", 20000, false, "i", playerid);
                }
			}
        }
        else return SendPlayerErrorMessage(playerid, " You currently do not have any lockpicks!");
	}
	return 1;
}

CMD:lockpick(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		if(PlayerData[playerid][Character_Has_Lockpick] == 0) return SendPlayerErrorMessage(playerid, " You cannot lockpick a house door, because you have no lockpicks!");
		{
			if(IsPlayerNearHouseDoor(playerid) && PlayerAtHouseID[playerid] != 0)
			{
				new string[256];
				format(string, sizeof(string), "> %s removes a lockpick from their pocket and starts to enter the property", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0);
				
				PlayerData[playerid][Character_Has_Lockpick] --;
				
				new hdoorid = PlayerAtHouseID[playerid];
				HouseData[hdoorid][House_Lock_Active] = 0;
				
				new equery[500];
		        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_lock_active` = 0 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
				mysql_tquery(connection, equery);
			}
			else return SendPlayerErrorMessage(playerid, " You are not near anything that can be lockpicked!");
		}
	}
	return 1;
}

CMD:call(playerid, params[])
{
	new phonenumber, matchfound;
	
	matchfound = 0;

    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(PlayerData[playerid][Character_Has_Phone] > 0)
        {
            if(sscanf(params, "i", phonenumber))
            {
			   	SendPlayerServerMessage(playerid, " /call [phonenumber]");
			}
			else
			{
			    if(phonenumber == 0) return SendPlayerErrorMessage(playerid, " This number is not currently in service!");
			    if(phonenumber == 111)
			    {
			        HasPlayerMadeAnEmergencyCall[playerid] = 1;
			        EmergencyCallTypeRequired[playerid] = 0;
			        EmergencyCallTypeReason[playerid] = 0;
			        
					new string[256];
					format(string, sizeof(string), "> %s removes their phone from their pocket and starts dialing a number", GetName(playerid));
	   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	   				
					format(string, sizeof(string), "[Phone] Emergency Responder says: Who is required? (police, fire or medical)");
                    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

			    }
			    else if(phonenumber == 999)
			    {
			        HasPlayerMadeRequestCall[playerid] = 1;
			        RequestCallType[playerid] = 0;
			        RequestCallReason[playerid] = 0;

					new string[256];
					format(string, sizeof(string), "> %s removes their phone from their pocket and starts dialing a number", GetName(playerid));
	   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					format(string, sizeof(string), "[Phone] Mechanic Dispatch says: Do you require assistance at your location?");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

			    }
			    else if(phonenumber == 888)
			    {
			        HasPlayerMadeRequestCall[playerid] = 2;
			        RequestCallType[playerid] = 0;
			        RequestCallReason[playerid] = 0;

					new string[256];
					format(string, sizeof(string), "> %s removes their phone from their pocket and starts dialing a number", GetName(playerid));
	   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					format(string, sizeof(string), "[Phone] Towing Dispatch says: Do you require assistance at your location?");
					SendNearbyMessage(playerid, 5.0, COLOR_WHITE, string);

			    }
			    else
			    {
			        if(PlayerData[playerid][Character_Has_SimCard] > 0)
        			{
				        for(new i = 0; i < MAX_PLAYERS; i++)
						{
						    if(PlayerData[i][Character_Phonenumber] == phonenumber && matchfound == 0)
				      		{
						    	matchfound = 1;
	                            HasPlayerMadeACall[playerid] = 1;
						    	WhoIsCalling[playerid] = i;
						    	WhoIsCalling[i] = playerid;

								new string[128];
							  	format(string, sizeof(string), "> %s phone starts ringing in their pocket", GetName(i));
							   	SendNearbyMessage(i, 30.0, COLOR_PURPLE, string);

							   	new dstring[256];
								format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} You have an incoming call from %s (/pickup to answer the phone)!", PlayerData[playerid][Character_Name]);
								SendClientMessage(i, COLOR_ORANGE, dstring);

								format(string, sizeof(string), "> %s removes their phone from their pocket and starts dialing a number", GetName(playerid));
							   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							   	format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} You have dialed an outgoing call to %s (/endcall to stop the line)!", PlayerData[i][Character_Name]);
								SendClientMessage(playerid, COLOR_ORANGE, dstring);

							   	print("match found");
							}
						}
						if(matchfound == 0)
						{
						    SendPlayerErrorMessage(playerid, " This number is not currently in service!");
						}
					}
					else return SendPlayerErrorMessage(playerid, " You cannot make non emergency calls because you don't have a simcard!");
			    }
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not currently have a phone!");
	}
	return 1;
}

CMD:pickup(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(PlayerData[playerid][Character_Has_Phone] > 0 && WhoIsCalling[playerid] != 9999999)
        {
            new string[128];
 			format(string, sizeof(string), "> %s answers their phone", GetName(playerid));
		 	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

		   	new dstring[256];
			format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} [Now you can talk into the phone]");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			HasCallBeenPickedUp[playerid] = 1;
					
 		   	for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
			{
				if(WhoIsCalling[targetid] == playerid)
				{
		            HasCallBeenPickedUp[targetid] = 1;
					
					format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} [They have picked up the phone call, you can now talk]");
					SendClientMessage(targetid, COLOR_ORANGE, dstring);
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not currently have any calls to answer!");
	}
	return 1;
}

CMD:endcall(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(HasPlayerMadeAnEmergencyCall[playerid] == 1)
        {
            HasPlayerMadeAnEmergencyCall[playerid] = 0;
        	EmergencyCallTypeRequired[playerid] = 0;
			EmergencyCallTypeReason[playerid] = 0;
			
			new string[128];
 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
		   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
        }
		else if(HasCallBeenPickedUp[playerid] == 1)
        {
            new string[128];
 			format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
		   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

		   	new dstring[256];
			format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} The phonecall has just ended!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			HasCallBeenPickedUp[playerid] = 0;
		 	WhoIsCalling[playerid] = 9999999;
					
		   	for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
			{
				if(WhoIsCalling[targetid] == playerid)
				{
				    format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(WhoIsCalling[playerid]));
                    SendNearbyMessage(targetid, 30.0, COLOR_PURPLE, string);

				   	format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} The phonecall has just ended!");
					SendClientMessage(targetid, COLOR_ORANGE, dstring);
					
					HasCallBeenPickedUp[targetid] = 0;
			
                    WhoIsCalling[targetid] = 9999999;
				}
			}
		}
		else if(HasPlayerMadeACall[playerid] == 1)
        {
			new string[128];
		  	format(string, sizeof(string), "> %s puts their phone away in their pocket", GetName(playerid));
		   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

		   	new dstring[256];
			format(dstring, sizeof(dstring), "[Phone]:{FFFFFF} The phonecall has just ended!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			HasPlayerMadeACall[playerid] = 0;
			
  		    WhoIsCalling[playerid] = 9999999;
			for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
			{
				if(WhoIsCalling[targetid] == playerid)
				{
                    WhoIsCalling[targetid] = 9999999;
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not currently have any calls to end!");
	}
	return 1;
}

CMD:paybill(playerid, params[])
{
    if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new billid;
	    
	    if(sscanf(params, "i", billid))
    	{
			SendPlayerServerMessage(playerid, " /paybill [billid]");
   		}
		else
		{
		    new query[128];
		    mysql_format(connection, query, sizeof(query), "SELECT * FROM `bill_information` WHERE `bill_id` = '%d' LIMIT 1", billid);
			mysql_tquery(connection, query, "OnBillPay");
		}
	}
	return 1;
}
    
CMD:bills(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `bill_information` WHERE `character_name` = '%e'", PlayerData[playerid][Character_Name]);
		mysql_tquery(connection, query, "OnBillCheck");
	}
	return 1;
}

CMD:billcustomer(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Faction] == 9)
	    {
		    new targetid, money;

		    if(sscanf(params, "ii", targetid, money))
		    {
		        SendPlayerServerMessage(playerid, " /billcustomer [targetid] [amount]");
		    }
		    else
		    {
				if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
		        if(IsPlayerNearPlayer(playerid, targetid, 5.0))
		        {
			        new query[2000];
	        		mysql_format(connection, query, sizeof(query), "INSERT INTO `bill_information` (`character_name`, `bill_amount`, `bill_type`, `bill_name`) VALUES ('%e', '%d','9','%e')", PlayerData[targetid][Character_Name], money, PlayerData[playerid][Character_Name]);
					mysql_tquery(connection, query);

				    new dstring[256];
					format(dstring, sizeof(dstring), "> You have just been given a bill of $%i, by %s (/paybill)!", money, GetName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "> You have just given a bill to %s for $%i!", GetName(targetid), money);
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "> %s has removed a bill sheet from their pocket and given %s a peice of paper", GetName(playerid), GetName(targetid));
					SendNearbyMessage(playerid,30.0, COLOR_PURPLE, dstring);
				}
				else return SendPlayerErrorMessage(playerid, " You are not near a player to bill a charge too!");
		    }
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

// DUDEFIX COMMANDS

CMD:shovel(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 8)
	    {
	        new vehicleid;
	        new Float:vPos[3];
	        
	        vehicleid = GetClosestVehicle(playerid);
			GetVehiclePos(vehicleid, vPos[0],vPos[1],vPos[2]);

			if(IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]))
            {
		        if(VehicleData[vehicleid][Vehicle_Faction] == 8 && HasPlayerGotShovel[playerid] == 0)
		        {
		        	GivePlayerWeapon(playerid, WEAPON_SHOVEL, 1);

		        	new string[128];
	  				format(string, sizeof(string), "> %s removes a shovel from the back of their vehicle", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					HasPlayerGotShovel[playerid] = 1;
				}
				else if(VehicleData[vehicleid][Vehicle_Faction] == 8 && HasPlayerGotShovel[playerid] == 1)
		        {
		        	ResetPlayerWeapons(playerid);

		        	new string[128];
	  				format(string, sizeof(string), "> %s places the shovel back into their vehicle", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					HasPlayerGotShovel[playerid] = 0;
				}
			}
		}
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}
		
CMD:fixpipe(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 8)
		{
	        if(DudefixJobID == 0) return SendPlayerErrorMessage(playerid, " There are no above ground pipes to fix!");
	        else if(HasPlayerGotShovel[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to have a shovel before you can fix this pipe [Go to the back of your vehicle /shovel]!");
	        else if(DudefixJobID == 1)
	        {
		        if(IsPlayerInRangeOfPoint(playerid, 30, 1349.8253,-1399.9447,13.3056))
		        {
		            DestroyDynamicObject(DudeFixObjectFive);
		            
		            MoveDynamicObject(DudeFixObjectOne, 1352.17017, -1397.91748, -20, 0.5, 26.52001, 71.70001, 116.57999);
		            MoveDynamicObject(DudeFixObjectTwo, 1352.20020, -1395.06470, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectThree, 1354.84485, -1398.43799, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectFour, 1348.37390, -1399.37317, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            
		            new string[128];
		  			format(string, sizeof(string), "> %s turns off the water supply and starts to slowly move away the peices", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.0, true, false, false, false, 0, SYNC_ALL);
		            
                    Repair_Timer[playerid] = SetTimerEx("RepairTimer", 10000, false, "i", playerid);
				}
				else return SendPlayerErrorMessage(playerid, " You are not near the active job site!");
			}
			else if(DudefixJobID == 2)
	        {
		        if(IsPlayerInRangeOfPoint(playerid, 30, 1529.4000,-1672.0344,13.3828))
		        {
		            DestroyDynamicObject(DudeFixObjectFive);
		            
		            MoveDynamicObject(DudeFixObjectOne, 1527.92517, -1671.25366, -20, 0.5, 14.40001, 10.56000, -139.56006);
		            MoveDynamicObject(DudeFixObjectTwo, 1527.42981, -1673.72827, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectThree, 1532.23157, -1673.28320, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectFour, 1526.41724, -1668.61755, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            
		            new string[128];
		  			format(string, sizeof(string), "> %s turns off the water supply and starts to slowly move away the peices", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
					ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.0, true, false, false, false, 0, SYNC_ALL);
		            
                    Repair_Timer[playerid] = SetTimerEx("RepairTimer", 10000, false, "i", playerid);
				}
				else return SendPlayerErrorMessage(playerid, " You are not near the active job site!");
			}
			else if(DudefixJobID == 3)
	        {
		        if(IsPlayerInRangeOfPoint(playerid, 30, 2090.9763,-1752.6794,13.4049))
		        {
		            DestroyDynamicObject(DudeFixObjectFive);
		            
		            MoveDynamicObject(DudeFixObjectOne, 2092.47217, -1751.63062, -20, 0.5, 46.67999, -10.44001, 0.00000);
		            MoveDynamicObject(DudeFixObjectTwo, 2090.65234, -1753.89099, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectThree, 2091.60034, -1749.64600, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            MoveDynamicObject(DudeFixObjectFour, 2094.53247, -1751.27051, -20, 0.5, 0.00000, 0.00000, 90.00000);
		            
		            new string[128];
		  			format(string, sizeof(string), "> %s turns off the water supply and starts to slowly move away the peices", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
					
					ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.0, true, false, false, false, 0, SYNC_ALL);
		            
                    Repair_Timer[playerid] = SetTimerEx("RepairTimer", 10000, false, "i", playerid);
				}
				else return SendPlayerErrorMessage(playerid, " You are not near the active job site!");
			}
		}
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

// LS BANK COMMANDS
CMD:computer(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 4 && PlayerData[playerid][Character_Faction_Rank] > 1)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 20, 2168.2319, 1603.6072, 999.9726))
	        {
	        	ShowPlayerDialog(playerid, DIALOG_BANK_FAC_LOGIN, DIALOG_STYLE_PASSWORD, "Los Santos Bank Computer", "Welcome to the Los Santos Bank Computer System\n\nThis system is where you will be able to review requested loans.\n\nPlease enter in your work password:", "Login", "Close");
			}
			else return SendPlayerErrorMessage(playerid, " You need to be inside the bank office to use this feature!");
		}
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:funds(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 4)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 20, 2168.2319, 1603.6072, 999.9726))
	        {
	        	new dstring[256];
				format(dstring, sizeof(dstring), "> You currently have $%d in your factions funds. If you need more, please request a money delivery or speak to an admin!", FactionData[4][Faction_Money], GetName(playerid));
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
			else return SendPlayerErrorMessage(playerid, " You need to be inside the bank office to use this feature!");
		}
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

// MECHANIC COMMANDS
CMD:fillvehicle(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 9)
	    {
		    new vehicleid = GetPlayerVehicleID(playerid);

		    if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    {
		        if(MechanicFuelAmount[playerid] <= 19) return SendPlayerErrorMessage(playerid, " You have a low amount of fuel on your persons, go back to the yard to refill your cans!");
		        else
		        {
			        if(VehicleData[vehicleid][Vehicle_Fuel] >= 20) return SendPlayerErrorMessage(playerid, " You cannot fill up a vehicle that has more than the allowed amount you can give!");
					else
					{
					    VehicleData[vehicleid][Vehicle_Fuel] += 20;
					    MechanicFuelAmount[playerid] -= 20;

					    new string[128];
					  	format(string, sizeof(string), "> %s adds a small amount of fuel to the vehicle to get it going", GetName(playerid));
					   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			        }
				}
		    }
		    else
		    {
		        SendPlayerErrorMessage(playerid, " You are not in the drivers seat of a vehicle you are fixing!");
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:fix(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 9)
	    {
		    new vehicleid = GetPlayerVehicleID(playerid);

		    if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    {
		        new Float:vehicleHealth;
	        	GetVehicleHealth(vehicleid, vehicleHealth);
	        	
		        if(vehicleHealth == 1000) return SendPlayerErrorMessage(playerid, " You cannot repair a vehicle that is sitting at full health!");
		        else
		        {
			        if(MechanicToolAmount[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have any more avaliable tools to use on this vehicle!");
					else
					{
					    MechanicToolAmount[playerid] -= 1;
						SetVehicleHealth(vehicleid, 1000);
						RepairVehicle(vehicleid);

					    new string[128];
					  	format(string, sizeof(string), "> %s starts fixing the vehicle from the issues that have been found", GetName(playerid));
					   	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			        }
				}
		    }
		    else
		    {
		        SendPlayerErrorMessage(playerid, " You are not in the drivers seat of a vehicle you are fixing!");
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:checkgear(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 9)
	    {
		    if(IsPlayerOnDuty[playerid] == 1)
   			{
				new string[128];
				
				SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Tool Bag Contents{FFFFFF} ***");
				format(string, sizeof(string), "> Tool Kits: %d", MechanicToolAmount[playerid]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "> Fuel Kits: %d", MechanicFuelAmount[playerid]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				
	  			format(string, sizeof(string), "> %s remove their tool bag and inspects the contents", GetName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

   			}
   			else return SendPlayerErrorMessage(playerid, " You are not on duty!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:tools(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 9)
	    {
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, 2054.3008,-1842.2689,13.5633))
		    {
		    	if(IsPlayerOnDuty[playerid] == 1)
	            {
			        MechanicFuelAmount[playerid] = 20;
			        MechanicToolAmount[playerid] = 5;
				
				    new string[128];
	  				format(string, sizeof(string), "> %s removes a fuel can and tool pack from the bench", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				
    			}
    			else return SendPlayerErrorMessage(playerid, " You are not on duty!");
		    }
		    else return SendPlayerErrorMessage(playerid, " You are not near the /tools point!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:startjob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(PlayerData[playerid][Character_Job] == 1 && PizzaJobDeliveryPlayer[playerid] == 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 2102.2109, -1789.1084, 13.5547))
		    {
                PizzaJobDeliveryPlayer[playerid] = 1;
				PizzaJobDeliveryCount[playerid] = 1;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just started the pizza delivery process. Go inside the store and make a pizza");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				SetPlayerCheckpoint(playerid, 374.7064, -117.2319, 1001.4922, 0.5);
				
				HasGPSBeenDisabled[playerid] = 1;
            }
            else return SendPlayerErrorMessage(playerid, " You are not near your job icon location!");
		}
		if(PlayerData[playerid][Character_Job] == 2 && GarbageJobPlayer[playerid] == 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 2201.1582,-1974.1382,13.5576))
		    {
                GarbageJobPlayer[playerid] = 1;
				GarbageJobCount[playerid] = 1;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just started the garbage collection job. Grab a truck and go service the community");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				new randomNumber = GetValidHouseJobNumber();
				SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 3.0);
				
				HasGPSBeenDisabled[playerid] = 1;
            }
            else return SendPlayerErrorMessage(playerid, " You are not near your job icon location!");
		}
		if(PlayerData[playerid][Character_Job] == 3 && ElectricianLightJobPlayer[playerid] == 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 992.1449,-1454.0868,13.5469))
		    {
                ElectricianLightJobPlayer[playerid] = 1;
				ElectricianLightJobCount[playerid] = 1;
				
				new dstring[256];
				format(dstring, sizeof(dstring), "- You have just started an electrician route, go and fix the traffic lights");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				new randIndex = random(sizeof(ElectricianJob1));
				SetPlayerCheckpoint(playerid, ElectricianJob1[randIndex][0],ElectricianJob1[randIndex][1],ElectricianJob1[randIndex][2], 3.0);
				
				HasGPSBeenDisabled[playerid] = 1;
            }
            else return SendPlayerErrorMessage(playerid, " You are not near your job icon location!");
		}
		if(PlayerData[playerid][Character_Faction] == 7)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 2128.1775,-2277.4907,20.6643))
		    {
                ShowPlayerDialog(playerid, DIALOG_JOB_VIEW, DIALOG_STYLE_LIST, "Trucking Company - Jobs", "1. Money Transport\n2. Parcel Transport", "Next", "Close");
            }
            else return SendPlayerErrorMessage(playerid, " You are not near your office desk, you cannot select a job here!");
		}
   	}
	return 1;
}

CMD:stopjob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(PlayerData[playerid][Character_Job] == 1 && PizzaJobDeliveryPlayer[playerid] == 1)
        {
            PizzaJobDeliveryPlayer[playerid] = 0;
			PizzaJobDeliveryCount[playerid] = 0;
				
			new dstring[256];
			format(dstring, sizeof(dstring), "- You have just ended your pizza delivery run!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			DisablePlayerCheckpoint(playerid);	
			RemovePlayerFromVehicle(playerid);
			
			HasGPSBeenDisabled[playerid] = 0;		
		}
		if(PlayerData[playerid][Character_Job] == 2 && GarbageJobPlayer[playerid] == 1)
        {
            GarbageJobPlayer[playerid] = 0;
			GarbageJobCount[playerid] = 0;
				
			new dstring[256];
			format(dstring, sizeof(dstring), "- You have just ended your truck run for collecting rubbish!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			DisablePlayerCheckpoint(playerid);	
			RemovePlayerFromVehicle(playerid);	
			
			HasGPSBeenDisabled[playerid] = 0;	
		}
		if(PlayerData[playerid][Character_Faction] == 7)
        {
            if(TruckJobParcelPlayer[playerid] > 0)
		    {
                new dstring[256];
				format(dstring, sizeof(dstring), "- You have just finished your current route!");
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

				TruckJobParcelCount[playerid] = 0;
		   		TruckJobParcelPlayer[playerid] = 0;
		
				DisablePlayerCheckpoint(playerid);
				
				HasGPSBeenDisabled[playerid] = 0;
            }
            else return SendPlayerErrorMessage(playerid, " You have not started a Trucking Job yet!");
		}
   	}
	return 1;
}

// LSMC COMMANDS
CMD:heal(playerid, params[])
{
	new targetid;
	
	if(PlayerData[playerid][Character_Faction] == 3)
	{
	    if(IsPlayerOnDuty[playerid] == 1)
		{
		    if(sscanf(params, "i", targetid))
   			{
				SendPlayerServerMessage(playerid, " /heal [targetid]");
			}
			else
			{
			    if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			    else
				{
				    new Float:health;
					GetPlayerHealth(targetid, health);
				    
					if(health > 80) return SendPlayerErrorMessage(playerid, " You cannot heal someone more than 80% of their health!");
					else
					{
					    new string[256];
		      			format(string, sizeof(string), "> %s has removed some medical supplies from their bag and applied them to %s", GetName(playerid), GetName(targetid));
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, true, false, false, false, 0, SYNC_ALL);
						
						PlayerData[targetid][Character_Health] = 80;
						SetPlayerHealth(targetid, 80);
					}
				}
			}
	    }
	    else return SendPlayerErrorMessage(playerid, " You need to be on duty to use this command!");
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}


// LSFD COMMANDS
CMD:fireex(playerid, params[])
{
	if(PlayerData[playerid][Character_Faction] == 2)
	{
	    if(IsPlayerOnDuty[playerid] == 1)
		{
	    	GivePlayerWeapon(playerid, WEAPON_FIREEXTINGUISHER, 99999);
	    	
	    	new string[256];
      		format(string, sizeof(string), "> %s has just grabbed a fire extinguisher from the lockers", GetName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	    }
	    else return SendPlayerErrorMessage(playerid, " You need to be on duty to use this command!");
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

// LSPD COMMANDS

CMD:showbadge(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid;

		if(sscanf(params, "i", targetid))
		{
			SendPlayerServerMessage(playerid, " /showbadge [targetid]");
   		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
		    new string[256], string1[256], string2[256];

	  		format(string, sizeof(string), "> %s has removed their ID from their pocket and handed it to %s", GetName(playerid), GetName(targetid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
			
			format(string1, sizeof(string1), "*** %s Badge ***", PlayerData[playerid][Character_Name]);
			SendClientMessage(targetid, COLOR_YELLOW, string1);
	
			format(string2, sizeof(string2), "> %s Badge | Status: Active", PlayerData[playerid][Character_Name]);
			SendClientMessage(targetid, COLOR_WHITE, string2);
		}
	}
	return 1;
}

CMD:megaphone(playerid, params[]) return cmd_mp(playerid,params);
CMD:mp(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Faction] == 1 || PlayerData[playerid][Character_Faction] == 2 || PlayerData[playerid][Character_Faction] == 3)
        {
			if(!IsPlayerInAnyVehicle(playerid))  return SendPlayerErrorMessage(playerid, " You are not within a specific vehicle to use this command!");
            if(isnull(params)) return SendPlayerServerMessage(playerid, " /m(egaphone) [Text]");
			else if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
			else
			{
	   			SendNearbyMessage(playerid, 50.0, COLOR_YELLOW, "([Megaphone] %s)", params);
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:search(playerid, params[])
{
	new targetid;
	
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(IsPlayerOnDuty[playerid] == 1)
			{
			    if(sscanf(params, "i", targetid))
	            {
			    	SendPlayerServerMessage(playerid, " /search [targetid]");
				}
				else
				{
     				if(targetid == playerid)
					{
					    return SendPlayerErrorMessage(playerid, " You cannot search yourself!");
					}
					if(targetid != INVALID_PLAYER_ID)
					{
					    WhoHasBeenSearched[playerid] = targetid;
					    
		   				new Float:tx, Float:ty, Float:tz;
			  		    GetPlayerPos(targetid, tx, ty, tz);

			  		    if(IsPlayerInRangeOfPoint(playerid, 3.0, tx, ty, tz))
			  		    {
                   		    GameTextForPlayer(targetid, "Being Searched...", 5000, 5);

			    		    new tdstring1[500];
					    	format(tdstring1, sizeof(tdstring1), "You have just been searched by the LSPD!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);
							
							new string[256];
				            format(string, sizeof(string), "> %s has just searched %s", GetName(playerid), GetName(targetid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
							
							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);

					        new bodytext[2000];
		           			format(bodytext, sizeof(bodytext), "Ropes:\t%i\nFuel Cans:\t%i\nLockpicks:\t%i\nDrugs:\t%i\nFood:\t%i\nDrinks:\t%i\nAlcohol:\t%i\nHacking Devices:\t%i", PlayerData[targetid][Character_Has_Rope], PlayerData[targetid][Character_Has_Fuelcan], PlayerData[targetid][Character_Has_Lockpick], PlayerData[targetid][Character_Has_Drugs], PlayerData[targetid][Character_Has_Food], PlayerData[targetid][Character_Has_Drinks], PlayerData[targetid][Character_Has_Alcohol], PlayerData[targetid][Character_Has_Device]);

							ShowPlayerDialog(playerid, DIALOG_LSPD_SEARCH, DIALOG_STYLE_TABLIST, "Searched Inventory..", bodytext, "Take Item", "Close");
			  		    }
			  		    else return SendPlayerErrorMessage(playerid, " You cannot search someone from this distance!");
					}
					else return SendPlayerErrorMessage(playerid, " You cannot search someone who isn't online!");
				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not on Duty!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:cbu(playerid, params[]) return cmd_cancelbackup(playerid,params);
CMD:cancelbackup(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(IsPlayerOnDuty[playerid] == 1)
			{
			    for(new i = 0; i < MAX_PLAYERS; i++)
				{
				    if(PlayerData[i][Character_Faction] == 1)
				    {
						DisablePlayerCheckpoint(i);
					}

			        LSPDBackupPosition[0] = 0;
			        LSPDBackupPosition[1] = 0;
			        LSPDBackupPosition[2] = 0;

			        BackupCaller = "";

			        KillTimer(Backup_Timer[i]);
				}
				
				new dstring[256];
	   			format(dstring, sizeof(dstring), "([BACKUP ALERT - UPDATE] %s has cancelled their backup request)", GetName(playerid));
				SendFactionRadioMessage(1, COLOR_YELLOW, dstring);
				
			}
			else return SendPlayerErrorMessage(playerid, " You are not on Duty!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:bu(playerid, params[]) return cmd_backup(playerid,params);
CMD:backup(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
		if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(IsPlayerOnDuty[playerid] == 1)
			{
				new Float:px, Float:py, Float:pz;
				GetPlayerPos(playerid, px, py, pz);
				
			    LSPDBackupPosition[0] = px;
			    LSPDBackupPosition[1] = py;
			    LSPDBackupPosition[2] = pz;
			    
			    new dstring[256];
	   			format(dstring, sizeof(dstring), "([BACKUP ALERT] %s has requested backup at their current location)", GetName(playerid));
				SendFactionRadioMessage(1, COLOR_YELLOW, dstring);
				
				BackupCaller = GetName(playerid);
				
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
				    if(PlayerData[i][Character_Faction] == 1)
				    {
						Backup_Timer[i] = SetTimerEx("BackupCheck", 2000, true, "i", i);
					}
				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not on Duty!");
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:mdc(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Faction] == 1)
        {
			if(IsLSPDVehicle(playerid))
	        {
		        if(PlayerData[playerid][Character_Faction] == 1)
		        {
		            new string[256];
		            format(string, sizeof(string), "> %s has just logged into the MDC", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   							
		            ShowPlayerDialog(playerid, DIALOG_MDC_MENU, DIALOG_STYLE_LIST, "Los Santos Government - MDC", "Search Player Records\nSearch Vehicle Records", "Select", "Close");
		        }
	        }
			else return SendPlayerErrorMessage(playerid, " You are not in an LSPD vehicle!");
        }
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    }
    return 1;
}

CMD:ticket(playerid, params[])
{
	if(PlayerData[playerid][Character_Faction] ==1)
	{
	    new targetid;
		new amount;
	    new reason[50];
	    new equery[2000];
	    
		if(sscanf(params, "iis[50]", targetid, amount, reason))
		{
			SendPlayerServerMessage(playerid, " /ticket [targetid] [amount] [reason]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
		    new Float:tx, Float:ty, Float:tz, Float:px, Float:py, Float:pz;
		    
		    GetPlayerPos(targetid, tx, ty, tz);
		    GetPlayerPos(playerid, px, py, pz);
		    
		    if(IsPlayerInRangeOfPoint(playerid, 10.0, px, py, pz))
		    {
				if(targetid == playerid)
				{
						new namestring[MAX_PLAYER_NAME];
					    format(namestring, sizeof(namestring), "%s", GetName(playerid));

						new string[256];
      					format(string, sizeof(string), "> %s writes out a ticket and hands it to %s", GetName(playerid), GetName(playerid));
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						
						format(string, sizeof(string), "> You have just been given a ticket of $%i for '%s' by Officer %s", amount, reason, GetName(playerid));
						SendClientMessage(playerid, COLOR_YELLOW, string);

                        PlayerData[playerid][Character_Ticket_Amount] = amount;
						PlayerData[playerid][Character_Total_Ticket_Amount] = PlayerData[playerid][Character_Total_Ticket_Amount] + amount;
						PlayerData[playerid][Character_Last_Crime] = reason;
						
                        mysql_format(connection, equery, sizeof(equery), "INSERT INTO `player_mdc_information` (`mdc_crime_character_name`, `mdc_crime_desc`, `mdc_crime_alert`) VALUES ('%e', '%s', '%i')", GetName(playerid), PlayerData[playerid][Character_Last_Crime], 1);
						mysql_tquery(connection, equery);
				
				}
			    else if(targetid != playerid)
			    {
                    new namestring[MAX_PLAYER_NAME];
			    	format(namestring, sizeof(namestring), "%s", GetName(playerid));

					new string[256];
   					format(string, sizeof(string), "> %s writes out a ticket and hands it to %s", GetName(playerid), GetName(targetid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

					format(string, sizeof(string), "> You have just been given a ticket of $%i for '%s' by Officer %s", amount, reason, GetName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);

                    PlayerData[playerid][Character_Ticket_Amount] = amount;
					PlayerData[playerid][Character_Total_Ticket_Amount] = PlayerData[playerid][Character_Total_Ticket_Amount] + amount;
					PlayerData[playerid][Character_Last_Crime] = reason;
					
					mysql_format(connection, equery, sizeof(equery), "INSERT INTO `player_mdc_information` (`mdc_crime_character_name`, `mdc_crime_desc`, `mdc_crime_alert`) VALUES ('%e', '%s', '%i')", GetName(targetid), PlayerData[targetid][Character_Last_Crime], 1);
					mysql_tquery(connection, equery);
				}
				else return SendPlayerErrorMessage(playerid, " You are not near this person to ticket!");
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:arrest(playerid, params[])
{
	if(PlayerData[playerid][Character_Faction] == 1)
	{
	    new targetid;
		new minutes;
	    new reason[50];
	    new equery[2000];

        if(IsPlayerInRangeOfPoint(playerid, 3.0, 254.4943,85.0860,1002.4453))
	    {
			if(sscanf(params, "iis[50]", targetid, minutes, reason))
			{
			    SendPlayerServerMessage(playerid, " /arrest [targetid] [minutes] [reason]");
			    SendPlayerServerMessage(playerid, " ((Do not arrest someone for more than 5 minutes for a basic crime))");
			}
			else
			{
			    if(targetid == playerid)return SendPlayerErrorMessage(playerid, " You cannot arrest yourself!");
			    if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			    else
			    {
					if(IsPlayerInRangeOfPoint(targetid, 10.0, 254.4943,85.0860,1002.4453))
					{
					    new randIndex = random(sizeof(PoliceJailSpawns));
						SetPlayerPos(targetid, PoliceJailSpawns[randIndex][0], PoliceJailSpawns[randIndex][1], PoliceJailSpawns[randIndex][2]);
						SetPlayerFacingAngle(targetid, 119.4812);

						SetPlayerInterior(targetid, 6);
						SetPlayerVirtualWorld(targetid, 1);

						new namestring[MAX_PLAYER_NAME];
					    format(namestring, sizeof(namestring), "%s", GetName(targetid));

						new dstring[256];
						format(dstring, sizeof(dstring), "[SERVER]:%s has been imprisoned by the police for: %s", GetName(targetid), reason);
						SendClientMessageToAll(COLOR_RED, dstring);

						SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this jail sentence action by taking a screenshot and reporting this on the forums!");
						SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}[/time to check remain sentence]");

                        PlayerData[targetid][Character_Jail_Time] = 1;
						PlayerData[targetid][Character_Jail_Time] = minutes;
						PlayerData[targetid][Character_Jail_Reason] = reason;
						
						mysql_format(connection, equery, sizeof(equery), "INSERT INTO `player_mdc_information` (`mdc_crime_character_name`, `mdc_crime_desc`, `mdc_crime_alert`) VALUES ('%e', '%s', '%i')", GetName(targetid), PlayerData[targetid][Character_Jail_Reason], 2);
						mysql_tquery(connection, equery);
					}
					else return SendPlayerErrorMessage(playerid, " You cannot arrest someone who isn't near the arrest point!");
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You cannot arrest someone when you are not near an arrest point!");
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:placeincar(playerid, params[]) return cmd_pic(playerid, params);
CMD:pic(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    new targetid;
	    
	    if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(sscanf(params, "i", targetid))
            {
		    	SendPlayerServerMessage(playerid, " /placeincar(pic) [targetid]");
			}
			else
			{
			    if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot place yourself into a vehicle!");
				if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
				else
		  		{
		  		    new Float:tx, Float:ty, Float:tz;
		  		    GetPlayerPos(targetid, tx, ty, tz);

		  		    if(IsPlayerCuffed[targetid] == 0) return SendPlayerErrorMessage(playerid, " You cannot place someone into a vehicle that isn't restrained!");

		  		    else if(IsPlayerInRangeOfPoint(playerid, 5.0, tx, ty, tz) && IsPlayerCuffed[targetid] == 1)
		  		    {
		  		        new Float:vPos[3];
						new vid;
						
						vid = GetClosestVehicle(playerid);
						GetVehiclePos(vid, vPos[0],vPos[1],vPos[2]);
						
						if(IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]))
						{
			  		        new tdstring1[500];
							format(tdstring1, sizeof(tdstring1), "You have been placed into a vehicle, roleplay must continue!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);
							
							PutPlayerInVehicle(targetid, vid, 3);

							new string[256];
	      					format(string, sizeof(string), "> %s has been placed into the vehicle by %s", GetName(targetid), GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else return SendPlayerErrorMessage(playerid, " There are no vehicles close to you!");
		  		    }
		  		    else return SendPlayerErrorMessage(playerid, " The person you are trying to place into a vehicle isn't near you!");
		  		}
			}
        }
        else if(PlayerData[playerid][Character_Faction] == 3)
        {
            if(sscanf(params, "i", targetid))
            {
		    	SendPlayerServerMessage(playerid, " /placeincar(pic) [targetid]");
			}
			else
			{
			    if(targetid == playerid)
				{
				    SendPlayerErrorMessage(playerid, " You cannot place yourself into a vehicle!");
				    return 1;
				}
				else
		  		{
		  		    new Float:tx, Float:ty, Float:tz;
		  		    GetPlayerPos(targetid, tx, ty, tz);

		  		    if(IsPlayerInRangeOfPoint(playerid, 5.0, tx, ty, tz))
		  		    {
		  		        new Float:vPos[3];
						new vid;

						vid = GetClosestVehicle(playerid);
						GetVehiclePos(vid, vPos[0],vPos[1],vPos[2]);

						if(IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]))
						{
			  		        new tdstring1[500];
							format(tdstring1, sizeof(tdstring1), "You have been placed into a vehicle, roleplay must continue!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);

							PutPlayerInVehicle(targetid, vid, 3);

							new string[256];
	      					format(string, sizeof(string), "> %s has been placed into the vehicle by %s", GetName(targetid), GetName(playerid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
						}
						else return SendPlayerErrorMessage(playerid, " There are no vehicles close to you!");
		  		    }
		  		    else return SendPlayerErrorMessage(playerid, " The person you are trying to place into a vehicle isn't near you!");
		  		}
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:cuff(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		new targetid;

        if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(sscanf(params, "i", targetid))
            {
		    	SendPlayerServerMessage(playerid, " /cuff [targetid]");
			}
			else
			{
			    if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot cuff yourself!");
				if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
				else
		  		{
		  		    new Float:tx, Float:ty, Float:tz;
		  		    GetPlayerPos(targetid, tx, ty, tz);

		  		    if(IsPlayerInRangeOfPoint(playerid, 5.0, tx, ty, tz))
		  		    {
		  		        if (GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_CUFFED)
		  		        {
		  		            IsPlayerCuffed[targetid] = 0;

			    		    GameTextForPlayer(targetid, "Uncuffed", 2000, 6);

			    		    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
							RemovePlayerAttachedObject(targetid, 0);

			    		    new tdstring1[500];
					    	format(tdstring1, sizeof(tdstring1), "You have had your cuffs taken off your body. You can now walk around freely!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);
							
							new string[256];
				            format(string, sizeof(string), "> %s has removed the cuffs from %s", GetName(playerid), GetName(targetid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);
		  		        }
		  		        else
		  		        {
			  		        IsPlayerCuffed[targetid] = 1;

			    		    GameTextForPlayer(targetid, "Cuffed", 2000, 6);

			    		    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
							SetPlayerAttachedObject(targetid, 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);

			    		    new tdstring2[500];
					    	format(tdstring2, sizeof(tdstring2), "You have been placed in cuffs by the LSPD, please wait for further roleplay instructions!");
							PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring2);
							PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);
							
							new string[256];
				            format(string, sizeof(string), "> %s has placed the cuffs on %s", GetName(playerid), GetName(targetid));
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							Notification_Timer[targetid] = SetTimerEx("OnTimerCancels", 5000, false, "i", targetid);
						}
		  		    }
		  		    else return SendPlayerErrorMessage(playerid, " You cannot cuff someone who isn't within the reachable vacinity of you!");
		  		}
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:taser(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		new targetid;
		
        if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(sscanf(params, "i", targetid))
            {
		    	SendPlayerServerMessage(playerid, " /taser [targetid]");
			}
			else
			{
				if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
				if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot taser yourself!");
				if(targetid != INVALID_PLAYER_ID)
				{
	   				new Float:tx, Float:ty, Float:tz;
		  		    GetPlayerPos(targetid, tx, ty, tz);

		  		    if(IsPlayerInRangeOfPoint(playerid, 15.0, tx, ty, tz))
		  		    {
		  		        IsPlayerTased[targetid] = 1;

		    		    GameTextForPlayer(targetid, "Tasered", 5000, 5);

		    		    new tdstring1[500];
				    	format(tdstring1, sizeof(tdstring1), "You have been tasered by the LSPD, please roleplay your injuries or face the overlords!");
						PlayerTextDrawSetString(targetid, PlayerText:Notification_Textdraw, tdstring1);
						PlayerTextDrawShow(targetid, PlayerText:Notification_Textdraw);
						
						new string[256];
      					format(string, sizeof(string), "> %s has tasered %s", GetName(playerid), GetName(targetid));
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

				        Notification_Timer[targetid] = SetTimerEx("TaserCancels", 5000, false, "i", targetid);
		  		    }
		  		    else return SendPlayerErrorMessage(playerid, " You cannot taser someone from this type of distance!");
				}
				else return SendPlayerErrorMessage(playerid, " You cannot taser a playerid that isn't online!");
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:acceptjob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
				new jobtype;
				
				if(sscanf(params, "i", jobtype))
	            {
				   	SendPlayerServerMessage(playerid, " /acceptjob [1 - Job | 2 - House Alarm]");
				}
				else
				{
			    	if(jobtype == 1)
					{
			            if(LSPDJobHouseInspection == 1 && LSPDJobHouseInspectionAccepted == 1)
			            {
			                SendPlayerErrorMessage(playerid, " Another officer has already accepted this job!");
			            }
			            else if(LSPDJobHouseInspection == 1 && LSPDJobHouseInspectionAccepted == 0)
			            {
							new randomNumber = GetValidHouseJobNumber();
		
			                SetPlayerCheckpoint(playerid, HouseData[randomNumber][House_Outside_X], HouseData[randomNumber][House_Outside_Y], HouseData[randomNumber][House_Outside_Z], 20.0);
		
			                new dstring[256];
							format(dstring, sizeof(dstring), "[GPS] We have marked the location of the job on your map!");
							SendClientMessage(playerid, COLOR_YELLOW, dstring);
		
							format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s is responding to the house inspection job)", GetName(playerid));
							SendFactionRadioMessage(1, COLOR_WHITE, dstring);
		
							LSPDJobHouseInspectionAccepted = 1;
							LSPDJobHouseInpPlayer[playerid] = 1;
		
							print("LSPD Job Accepted");
			            }
			            else return SendPlayerErrorMessage(playerid, " You cannot accept a job at this time!");
					}
					else if(jobtype == 2)
					{
			            if(HOUSE_ALARM_ID == 0)
			            {
			                SendPlayerErrorMessage(playerid, " There is no active alarm jobs at this time!");
			            }
			            else
			            {		
			                SetPlayerCheckpoint(playerid, HouseData[HOUSE_ALARM_ID][House_Outside_X], HouseData[HOUSE_ALARM_ID][House_Outside_Y], HouseData[HOUSE_ALARM_ID][House_Outside_Z], 20.0);
		
			                new dstring[256];
							format(dstring, sizeof(dstring), "[GPS] We have marked the location of the job on your map!");
							SendClientMessage(playerid, COLOR_YELLOW, dstring);
		
							format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s is responding to the house alarm job [Address: %s])", GetName(playerid), HouseData[HOUSE_ALARM_ID][House_Address]);
							SendFactionRadioMessage(1, COLOR_WHITE, dstring);
		
							HOUSE_ALARM_ID = 0;
		
							print("LSPD Alarm Accepted");
			            }
					}
				}
			}
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		else if(PlayerData[playerid][Character_Faction] == 2)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 1)
	            {
	                SendPlayerErrorMessage(playerid, " Another officer has already accepted this job!");
	            }
	            else if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 0)
	            {
	                SetPlayerCheckpoint(playerid, HouseData[LSFDJobHouseFireID][House_Outside_X], HouseData[LSFDJobHouseFireID][House_Outside_Y], HouseData[LSFDJobHouseFireID][House_Outside_Z], 20.0);

	                new dstring[256];
					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the house fire on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s is responding to the house fire job)", GetName(playerid));
					SendFactionRadioMessage(2, COLOR_WHITE, dstring);

					LSFDJobHouseFireAccepted = 1;
					LSFDJobHouseFirePlayer[playerid] = 1;

					print("LSFD Job Accepted");
	            }
	            else return SendPlayerErrorMessage(playerid, " You cannot accept a job at this time!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		else if(PlayerData[playerid][Character_Faction] == 8)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(DudefixJob == 1 && DudefixJobAccepted == 1)
	            {
	                SendPlayerErrorMessage(playerid, " Another person has already responded to this job!");
	            }
	            else if(DudefixJob == 1 && DudefixJobAccepted == 0)
	            {
	                new Float:x, Float:y, Float:z;
                    if(DudefixJobID == 1)
	                {
	                    x = 1349.8253;
	                    y = -1399.9447;
	                    z = 13.3056;
	                }
	                else if(DudefixJobID == 2)
	                {
	                    x = 1529.4000;
	                    y = -1672.0344;
	                    z = 13.3828;
	                }
	                else if(DudefixJobID == 3)
	                {
	                    x = 2090.9763;
	                    y = -1752.6794;
	                    z = 13.4049;
	                }

	                SetPlayerCheckpoint(playerid, x, y, z, 20.0);

	                new dstring[256];
					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the pipe on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Engineer %s is responding to the burst pipe job)", GetName(playerid));
					SendFactionRadioMessage(8, COLOR_WHITE, dstring);

					DudefixJobAccepted = 1;
					DudefixJobPlayer[playerid] = 1;

					print("Dudefix Job Accepted");
	            }
	            else return SendPlayerErrorMessage(playerid, " You cannot accept a job at this time!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		else if(PlayerData[playerid][Character_Faction] == 9)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(MechanicJob == 1 && MechanicJobAccepted == 1)
	            {
	                SendPlayerErrorMessage(playerid, " Another unit has already accepted this job!");
	            }
	            else if(MechanicJob == 1 && MechanicJobAccepted == 0)
	            {
	                new Float:vehx, Float:vehy, Float:vehz;
     				GetVehiclePos(MechanicJobID, vehx, vehy, vehz);
     	
	                SetPlayerCheckpoint(playerid, vehx, vehy, vehz, 5.0);

	                new dstring[256];
					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the vehicle on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);

					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Mechanic %s is responding to the vehicle job)", GetName(playerid));
					SendFactionRadioMessage(9, COLOR_WHITE, dstring);

					MechanicJobAccepted = 1;
					MechanicJobPlayer[playerid] = 1;

					print("Mechanic Job Accepted");
	            }
	            else return SendPlayerErrorMessage(playerid, " You cannot accept a job at this time!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
   	}
	return 1;
}

CMD:canceljob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
		if(PlayerData[playerid][Character_Faction] == 1)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(LSPDJobHouseInspection == 1 && LSPDJobHouseInspectionAccepted == 1)
	            {
	                new dstring[256];
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s has just cancelled the inspection job they accepted)", GetName(playerid));
					SendFactionRadioMessage(1, COLOR_WHITE, dstring);

					DisablePlayerCheckpoint(playerid);

					LSPDJobHouseInspection = 0;
					LSPDJobHouseInspectionAccepted = 0;
					LSPDJobHouseInpPlayer[playerid] = 0;

					print("LSPD Job Cancelled");
	            }
	            else return SendPlayerErrorMessage(playerid, " There is no active jobs right now!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		if(PlayerData[playerid][Character_Faction] == 2)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(LSFDJobHouseFire == 1 && LSFDJobHouseFireAccepted == 1)
	            {
	                new dstring[256];
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s has just cancelled the fire job they accepted)", GetName(playerid));
					SendFactionRadioMessage(2, COLOR_WHITE, dstring);

					DisablePlayerCheckpoint(playerid);

					LSFDJobHouseFire = 0;
					LSFDJobHouseFireAccepted = 0;
					LSFDJobHouseFirePlayer[playerid] = 0;

					print("LSPD Job Cancelled");
	            }
	            else return SendPlayerErrorMessage(playerid, " There is no active jobs right now!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		if(PlayerData[playerid][Character_Faction] == 9)
        {
            if(IsPlayerOnDuty[playerid] == 1)
            {
	            if(MechanicJob == 1 && MechanicJobAccepted == 1 && MechanicJobPlayer[playerid] == 1)
	            {
	                new dstring[256];
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Mechanic %s has just cancelled the vehicle job they accepted)", GetName(playerid));
					SendFactionRadioMessage(9, COLOR_WHITE, dstring);

					DisablePlayerCheckpoint(playerid);

					MechanicJob = 0;
					MechanicJobAccepted = 0;
					MechanicJobPlayer[playerid] = 0;
					
					ClearAnimations(playerid);
            		
            		if(Repair_Timer[playerid] != 0)
					{
						KillTimer(Repair_Timer[playerid]);
            			Repair_Timer[playerid] = 0;
					}

					print("Mechanic Job Cancelled");
	            }
	            else return SendPlayerErrorMessage(playerid, " There is no active jobs right now!");
            }
			else return SendPlayerErrorMessage(playerid, " You cannot use this command off duty!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
   	}
	return 1;
}

// MULTIPLE FACTION  / JOB COMMANDS
CMD:acceptcall(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Faction] == 1 && IsPlayerOnDuty[playerid] == 1)
	    {
	        new targetid;
			if(sscanf(params, "i", targetid))
		 	{
				SendPlayerServerMessage(playerid, " /acceptcall [job id]");
		  	}
		  	else
		  	{
                if(EmergencyCallTypeRequired[targetid] == 1)
                {
                    new dstring[256];
					new Float:x, Float:y, Float:z;
					GetPlayerPos(targetid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);
					
					format(dstring, sizeof(dstring), "[PHONE TEXT] An officer is enroute to your location!");
					SendClientMessage(targetid, COLOR_AQUABLUE, dstring);
					
					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the caller on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);
					
					
					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Officer %s is responding to call id: %d)", GetName(playerid), targetid);
					SendFactionRadioMessage(1, COLOR_WHITE, dstring);
					
					EmergencyCallTypeRequired[targetid] = 0;
					EmergencyCallTypeReason[targetid] = 0;
                }
                else return SendPlayerErrorMessage(playerid, " This job id doesn't exist, please try again!");
			}
		}
		else if(PlayerData[playerid][Character_Faction] == 2 && IsPlayerOnDuty[playerid] == 1)
	    {
	        new targetid;
			if(sscanf(params, "i", targetid))
		 	{
				SendPlayerServerMessage(playerid, " /acceptcall [job id]");
		  	}
		  	else
		  	{
                if(EmergencyCallTypeRequired[targetid] == 2)
                {
                    new dstring[256];
					new Float:x, Float:y, Float:z;
					GetPlayerPos(targetid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);

					format(dstring, sizeof(dstring), "[PHONE TEXT] A fire unit is enroute to your location!");
					SendClientMessage(targetid, COLOR_AQUABLUE, dstring);

					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the caller on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);


					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Fireman %s is responding to call id: %d)", GetName(playerid), targetid);
					SendFactionRadioMessage(2, COLOR_WHITE, dstring);

					EmergencyCallTypeRequired[targetid] = 0;
					EmergencyCallTypeReason[targetid] = 0;
                }
                else return SendPlayerErrorMessage(playerid, " This job id doesn't exist, please try again!");
			}
		}
		else if(PlayerData[playerid][Character_Faction] == 3 && IsPlayerOnDuty[playerid] == 1)
	    {
	        new targetid;
			if(sscanf(params, "i", targetid))
		 	{
				SendPlayerServerMessage(playerid, " /acceptcall [job id]");
		  	}
		  	else
		  	{
                if(EmergencyCallTypeRequired[targetid] == 3)
                {
                    new dstring[256];
					new Float:x, Float:y, Float:z;
					GetPlayerPos(targetid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);

					format(dstring, sizeof(dstring), "[PHONE TEXT] A paramedic is enroute to your location!");
					SendClientMessage(targetid, COLOR_AQUABLUE, dstring);

					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the caller on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);


					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Paramedic %s is responding to call id: %d)", GetName(playerid), targetid);
					SendFactionRadioMessage(3, COLOR_WHITE, dstring);

					EmergencyCallTypeRequired[targetid] = 0;
					EmergencyCallTypeReason[targetid] = 0;
                }
                else return SendPlayerErrorMessage(playerid, " This job id doesn't exist, please try again!");
			}
		}
		else if(PlayerData[playerid][Character_Faction] == 9 && IsPlayerOnDuty[playerid] == 1)
	    {
	        new targetid;
			if(sscanf(params, "i", targetid))
		 	{
				SendPlayerServerMessage(playerid, " /acceptcall [job id]");
		  	}
		  	else
		  	{
                if(HasPlayerMadeRequestCall[targetid] == 1)
                {
                    new dstring[256];
					new Float:x, Float:y, Float:z;
					GetPlayerPos(targetid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);

					format(dstring, sizeof(dstring), "[PHONE TEXT] A mechanic is heading to your current location!");
					SendClientMessage(targetid, COLOR_AQUABLUE, dstring);

					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the caller on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);


					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Mechanic %s is responding to call id: %d)", GetName(playerid), targetid);
					SendFactionRadioMessage(9, COLOR_WHITE, dstring);

					RequestCallType[targetid] = 0;
					RequestCallReason[targetid] = 0;
					HasPlayerMadeRequestCall[targetid] = 0;
                }
                else return SendPlayerErrorMessage(playerid, " This job id doesn't exist, please try again!");
			}
		}
		else if(PlayerData[playerid][Character_Faction] == 5 && IsPlayerOnDuty[playerid] == 1)
	    {
	        new targetid;
			if(sscanf(params, "i", targetid))
		 	{
				SendPlayerServerMessage(playerid, " /acceptcall [job id]");
		  	}
		  	else
		  	{
                if(HasPlayerMadeRequestCall[targetid] == 2)
                {
                    new dstring[256];
					new Float:x, Float:y, Float:z;
					GetPlayerPos(targetid, x, y, z);
					SetPlayerCheckpoint(playerid, x, y, z, 3.0);

					format(dstring, sizeof(dstring), "[PHONE TEXT] A tow truck is heading to your current location!");
					SendClientMessage(targetid, COLOR_AQUABLUE, dstring);

					format(dstring, sizeof(dstring), "[GPS] We have marked the location of the caller on your map!");
					SendClientMessage(playerid, COLOR_YELLOW, dstring);


					format(dstring, sizeof(dstring), "([Faction Radio] Dispatch: Tow Operator %s is responding to call id: %d)", GetName(playerid), targetid);
					SendFactionRadioMessage(9, COLOR_WHITE, dstring);

					RequestCallType[targetid] = 0;
					RequestCallReason[targetid] = 0;
					HasPlayerMadeRequestCall[targetid] = 0;
                }
                else return SendPlayerErrorMessage(playerid, " This job id doesn't exist, please try again!");
			}
		}
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:drag(playerid, params[])
{
    new targetid;
    
	if(sscanf(params, "i", targetid))
 	{
		SendPlayerServerMessage(playerid, " /drag [targetid]");
  	}
  	else
  	{
		if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  	    if(IsPlayerCuffed[targetid] == 1 && PlayerData[playerid][Character_Faction] == 1)
  	    {
  	        if(IsPlayerDragged[targetid] == 1)
			{
  	            
            	IsPlayerDragged[targetid] = 11111;
            	TogglePlayerControllable(targetid,false);
            	
            	WhoIsDragging[targetid] = 11111;
            	
            	KillTimer(Drag_Timer[targetid]);
			}
			else
			{
			    IsPlayerDragged[targetid] = 1;
			    TogglePlayerControllable(targetid,true);
			    
			    WhoIsDragging[targetid] = playerid;
			    
			    Drag_Timer[targetid] = SetTimerEx("DragTimer", 1000, true, "i", targetid);
			}
		}
		else if(PlayerData[playerid][Character_Faction] == 3)
  	    {
  	        if(IsPlayerDragged[targetid] == 1)
			{

            	IsPlayerDragged[targetid] = 11111;
            	TogglePlayerControllable(targetid,false);

            	WhoIsDragging[targetid] = 11111;

            	KillTimer(Drag_Timer[targetid]);
			}
			else
			{
			    IsPlayerDragged[targetid] = 1;
			    TogglePlayerControllable(targetid,true);

			    WhoIsDragging[targetid] = playerid;

			    Drag_Timer[targetid] = SetTimerEx("DragTimer", 1000, true, "i", targetid);
			}
		}
  	    else if(IsPlayerTied[targetid] == 1)
		{
		    if(IsPlayerDragged[targetid] == 1)
  	        {
                IsPlayerDragged[targetid] = 11111;
                TogglePlayerControllable(targetid,false);
                
                WhoIsDragging[targetid] = 11111;
                
                KillTimer(Drag_Timer[targetid]);
			}
			else
			{
			    IsPlayerDragged[targetid] = 1;
			    TogglePlayerControllable(targetid,true);
			    
			    WhoIsDragging[targetid] = playerid;
			    
			    Drag_Timer[targetid] = SetTimerEx("DragTimer", 1000, true, "i", targetid);
			}
		}
		else return SendPlayerErrorMessage(playerid, " You cannot drag someone who isn't cuffed or tied up!");
  	}
  	return 1;
}

CMD:issuelicense(playerid, params[])
{
    if(PlayerData[playerid][Character_Faction] == 1 && PlayerData[playerid][Character_Faction_Rank] == 6)
	{
	    new targetid, license, status;

	    if(sscanf(params, "iii", targetid, license, status))
	    {
	        SendPlayerServerMessage(playerid, " /issuelicense [targetid] [license type] [status]");
		    SendPlayerServerMessage(playerid, " Licenses: [1 - Motorcycle | 2 - Car | 3 - Truck | 4 - Boat | 5 - Flying | 6 - Firearms]");
		    SendPlayerServerMessage(playerid, " Status: [1 - Issue | 2 - Revoke]");
	    }
	    else
	    {
	        if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot issue a license to yourself!");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				new Float:tx, Float:ty, Float:tz;
		    	GetPlayerPos(targetid, tx, ty, tz);
		    	
		    	new string[256];

	  		    if(IsPlayerInRangeOfPoint(playerid, 5.0, tx, ty, tz))
	  		    {
					if(license == 1)
					{
					    PlayerData[targetid][Character_License_Motorcycle] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_motorcycle` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Motorcycle], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    		
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Motorcycle License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Motorcycle License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Motorcycle License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   							

							format(string, sizeof(string), "> You have revoked a Motorcycle License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
					else if(license == 2)
					{
					    PlayerData[targetid][Character_License_Car] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_car` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Car], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    	
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Car License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Car License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Car License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have revoked a Car License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
					else if(license == 3)
					{
					    PlayerData[targetid][Character_License_Truck] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_truck` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Truck], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    	
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Truck License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Truck License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Truck License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have revoked a Truck License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
					else if(license == 4)
					{
					    PlayerData[targetid][Character_License_Boat] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_boat` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Boat], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    	
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Boat License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Boat License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Boat License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have revoked a Boat License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
					else if(license == 5)
					{
					    PlayerData[targetid][Character_License_Flying] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_flying` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Flying], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    	
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Boat License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Boat License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Boat License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have revoked a Boat License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
					else if(license == 6)
					{
					    PlayerData[targetid][Character_License_Firearms] = status;
					    
					    new updatequery[2000];
    					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_firearms` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Firearms], GetName(targetid));
				    	mysql_tquery(connection, updatequery);
				    	
					    if(status == 1)
					    {
                            format(string, sizeof(string), "> %s has just issued %s a Firearms License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have issued a Firearms License to %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					    else
					    {
                            format(string, sizeof(string), "> %s has just revoked %s's Firearms License", GetName(playerid), GetName(targetid));
   							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

							format(string, sizeof(string), "> You have revoked a Firearms License from %s!", GetName(targetid));
							SendClientMessage(playerid, COLOR_YELLOW, string);
					    }
					}
				}
				else return SendPlayerErrorMessage(playerid, " You cannot issue a license to someone, while they are far away!");
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:fradio(playerid, params[]) return cmd_fr(playerid,params);
CMD:fr(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Faction] > 0)
        {
            if(isnull(params)) return SendPlayerServerMessage(playerid, " /fr(adio) [Text]");
			else if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
			else
			{
	            new factionradioid = PlayerData[playerid][Character_Faction];
	            new dstring[256];
	            
	   			format(dstring, sizeof(dstring), "([Faction Radio] %s: %s)", GetName(playerid), params);
				SendFactionRadioMessage(factionradioid, COLOR_WHITE, dstring);
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:gradio(playerid, params[]) return cmd_gr(playerid,params);
CMD:gr(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Faction] == 1 || PlayerData[playerid][Character_Faction] == 2 || PlayerData[playerid][Character_Faction] == 3 || PlayerData[playerid][Character_Faction] == 5)
        {
            if(isnull(params)) return SendPlayerServerMessage(playerid, " /gr(adio) [Text]");
			else if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
			else
			{
	            new dstring[256];
	            
	   			format(dstring, sizeof(dstring), "([Gov Radio] %s: %s)", GetName(playerid), params);
				SendGovRadioMessage(COLOR_WHITE, dstring);
			}
        }
        else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:radio(playerid, params[]) return cmd_r(playerid,params);
CMD:r(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Radio] > 0)
        {
            if(isnull(params)) return SendPlayerServerMessage(playerid, " /r(adio) [Text]");
			else if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
			
            new radiofreq = PlayerData[playerid][Character_Radio];
            new dstring[256];

   			format(dstring, sizeof(dstring), "([Radio] %s: %s))", GetName(playerid), params);
			SendFactionRadioMessage(radiofreq, COLOR_WHITE, dstring);
        }
        else return SendPlayerErrorMessage(playerid, " You do not have a radio to talk to anyone with!");
	}
	return 1;
}

CMD:duty(playerid, params[])
{
    if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    else
    {
        if(PlayerData[playerid][Character_Faction] == 1)
        {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 254.4426,76.9794,1003.6406))
			{
				if(IsPlayerOnDuty[playerid] == 1)
     			{
	           		SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);

				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(1, COLOR_YELLOW, dstring);

					new string[256];
		      		format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    switch(PlayerData[playerid][Character_Faction_Rank])
					    {
					        case 1: SetPlayerSkin(playerid, 280);
					        case 2: SetPlayerSkin(playerid, 281);
					        case 3: SetPlayerSkin(playerid, 282);
					        case 4: SetPlayerSkin(playerid, 284);
					        case 5: SetPlayerSkin(playerid, 283);
					        case 6: SetPlayerSkin(playerid, 288);
					    }
					}
					else
					{
						switch(PlayerData[playerid][Character_Faction_Rank])
						{
   							case 1: SetPlayerSkin(playerid, 306);
					        case 2: SetPlayerSkin(playerid, 306);
					        case 3: SetPlayerSkin(playerid, 306);
					        case 4: SetPlayerSkin(playerid, 284);
					        case 5: SetPlayerSkin(playerid, 307);
					        case 6: SetPlayerSkin(playerid, 307);
					    }
					}

					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);
					
					ResetPlayerWeapons(playerid);
					GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
					GivePlayerWeapon(playerid, WEAPON_DEAGLE, 24);
					GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 10);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(1, COLOR_YELLOW, dstring);

					new string[256];
		      		format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else if(PlayerData[playerid][Character_Faction] == 2)
        {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1780.0322,-1693.6436,16.7503))
       		{
	   			if(IsPlayerOnDuty[playerid] == 1)
  				{
		            SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);
				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(2, COLOR_YELLOW, dstring);
						
					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    switch(PlayerData[playerid][Character_Faction_Rank])
					    {
					        case 1: SetPlayerSkin(playerid, 277);
					        case 2: SetPlayerSkin(playerid, 278);
					        case 3: SetPlayerSkin(playerid, 279);
					        case 4: SetPlayerSkin(playerid, 311);
					        case 5: SetPlayerSkin(playerid, 310);
					        case 6: SetPlayerSkin(playerid, 303);
					    }
	                }
					else
					{
					    switch(PlayerData[playerid][Character_Faction_Rank])
					    {
					        case 1: SetPlayerSkin(playerid, 308);
					        case 2: SetPlayerSkin(playerid, 309);
					        case 3: SetPlayerSkin(playerid, 309);
					        case 4: SetPlayerSkin(playerid, 309);
					        case 5: SetPlayerSkin(playerid, 309);
					        case 6: SetPlayerSkin(playerid, 211);
					    }
					}

					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

					ResetPlayerWeapons(playerid);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(2, COLOR_YELLOW, dstring);
						
					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else if(PlayerData[playerid][Character_Faction] == 3)
        {
   			if(IsPlayerInRangeOfPoint(playerid, 3.0, -1098.1952,1995.3502,-58.9141))
		    {
		    	if(IsPlayerOnDuty[playerid] == 1)
	            {
	                SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);

				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(3, COLOR_YELLOW, dstring);
						
					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    switch(PlayerData[playerid][Character_Faction_Rank])
					    {
					        case 1: SetPlayerSkin(playerid, 275);
					        case 2: SetPlayerSkin(playerid, 276);
					        case 3: SetPlayerSkin(playerid, 276);
					        case 4: SetPlayerSkin(playerid, 276);
					        case 5: SetPlayerSkin(playerid, 70);
					        case 6: SetPlayerSkin(playerid, 274);
					    }
	                }
					else
					{
					    switch(PlayerData[playerid][Character_Faction_Rank])
					    {
					        case 1: SetPlayerSkin(playerid, 308);
					        case 2: SetPlayerSkin(playerid, 309);
					        case 3: SetPlayerSkin(playerid, 309);
					        case 4: SetPlayerSkin(playerid, 309);
					        case 5: SetPlayerSkin(playerid, 309);
					        case 6: SetPlayerSkin(playerid, 211);
					    }
					}

					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

					ResetPlayerWeapons(playerid);
					GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
					GivePlayerWeapon(playerid, WEAPON_DEAGLE, 24);
					GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 10);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(3, COLOR_YELLOW, dstring);
						
					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else if(PlayerData[playerid][Character_Faction] == 9)
        {
   			if(IsPlayerInRangeOfPoint(playerid, 3.0, 2051.0803,-1842.6533,13.5633))
		    {
		    	if(IsPlayerOnDuty[playerid] == 1)
	            {
	                SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);

				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(9, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    SetPlayerSkin(playerid, 50);
	                }
					else
					{
					    SetPlayerSkin(playerid, 131);
					}

					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

					ResetPlayerWeapons(playerid);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(9, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else if(PlayerData[playerid][Character_Faction] == 5)
        {
   			if(IsPlayerInRangeOfPoint(playerid, 3.0, 1511.0210,-1464.6028,9.5000))
		    {
		    	if(IsPlayerOnDuty[playerid] == 1)
	            {
	                SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);

				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(5, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    SetPlayerSkin(playerid, 50);
	                }
					else
					{
					    SetPlayerSkin(playerid, 131);
					}

					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

					ResetPlayerWeapons(playerid);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(5, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else if(PlayerData[playerid][Character_Faction] == 8)
        {
   			if(IsPlayerInRangeOfPoint(playerid, 3.0, 618.3365,-76.9667,997.9922))
		    {
		    	if(IsPlayerOnDuty[playerid] == 1)
	            {
	                SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin_1]);

				    ResetPlayerWeapons(playerid);

				    IsPlayerOnDuty[playerid] = 0;

                    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
				    GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GivePlayerWeapon(playerid, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone off duty!", GetName(playerid));
					SendFactionOOCMessage(8, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their civilian clothing and gone off duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
				}
				else
				{
				    if(IsEqual(PlayerData[playerid][Character_Sex], "Male", false))
	                {
	                    SetPlayerSkin(playerid, 50);
	                }
					else
					{
					    SetPlayerSkin(playerid, 131);
					}										
										
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MELEE, WEAPON:PlayerData[playerid][Weapon_Slot_1], PlayerData[playerid][Ammo_Slot_1]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_PISTOL, WEAPON:PlayerData[playerid][Weapon_Slot_2], PlayerData[playerid][Ammo_Slot_2]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_SHOTGUN, WEAPON:PlayerData[playerid][Weapon_Slot_3], PlayerData[playerid][Ammo_Slot_3]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_MACHINE_GUN, WEAPON:PlayerData[playerid][Weapon_Slot_4], PlayerData[playerid][Ammo_Slot_4]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_ASSAULT_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_5], PlayerData[playerid][Ammo_Slot_5]);
					GetPlayerWeaponData(playerid, WEAPON_SLOT_LONG_RIFLE, WEAPON:PlayerData[playerid][Weapon_Slot_6], PlayerData[playerid][Ammo_Slot_6]);

					ResetPlayerWeapons(playerid);

		        	IsPlayerOnDuty[playerid] = 1;

		        	new dstring[256];
		        	format(dstring, sizeof(dstring), "[DUTY ALERT] %s has just gone on duty and is avaliable for calls!", GetName(playerid));
					SendFactionOOCMessage(8, COLOR_YELLOW, dstring);

					new string[256];
   					format(string, sizeof(string), "> %s has just changed into their work clothing and gone on duty", GetName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
   				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not near a duty point!");
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
   }
	return 1;
}

// BANK COMMANDS

CMD:bankaccount(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    if(PlayerData[playerid][Character_Bank_Account] == 0)
	    {
	        for(new i; i<sizeof BankDeskLocations; i++)
			{
		        if(IsPlayerInRangeOfPoint(playerid, 3.0, BankDeskLocations[i][0], BankDeskLocations[i][1], BankDeskLocations[i][2]))
		        {
           			ShowPlayerDialog(playerid, DIALOG_BANK_REGISTER, DIALOG_STYLE_PASSWORD, "Los Santos Bank", "It appears that you do not have an open account with us!\n\nPlease enter in a password below that you want to use for this account.\n\n(There will be a $100 fee to the end user for the cost of setting the account up)", "Register", "Close");
				}
				else return SendPlayerErrorMessage(playerid, " You are not near the tellers desk in the bank!");
			}
		}
	    else
	    {
	        for(new i; i<sizeof BankDeskLocations; i++)
			{
		        if(IsPlayerInRangeOfPoint(playerid, 3.0, BankDeskLocations[i][0], BankDeskLocations[i][1], BankDeskLocations[i][2]))
		        {
		        	ShowPlayerDialog(playerid, DIALOG_BANK_LOGIN, DIALOG_STYLE_PASSWORD, "Los Santos Bank", "Welcome back to the Los Santos Bank!\n\nPlease enter in the password you used to set the account up.", "Login", "Close");
				}
				else return SendPlayerErrorMessage(playerid, " You are not near the tellers desk in the bank!");
			}
	    }
	}
	return 1;
}

// VEHICLE COMMANDS

CMD:fillup(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    
	    if(IsPlayerInRangeOfPoint(playerid, 10.0, 1938.3210, -1776.3223, 13.2729) && IsPlayerInVehicle(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        if(VehicleData[vehicleid][Vehicle_Fuel] == 100) return SendPlayerErrorMessage(playerid, " You cannot fill up a vehicle that has no more room in its tank!");
			else
			{
			    GameTextForPlayer(playerid, "~r~Calculating Fuel...", 5000, 5);
             	Refuel_Timer[playerid] = SetTimerEx("RefuelTimer", 5000, false, "i", playerid);
	        }
	    }
	    else
	    {
	        SendPlayerErrorMessage(playerid, " You are not near a gas station, in a vehicle or a driver of a vehicle!");
	    }
	}
	return 1;
}

CMD:recyclecar(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    new vehicleid, blankstring[50];
	    vehicleid = GetPlayerVehicleID(playerid);
	    blankstring = " ";

		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");
		if(VehicleData[vehicleid][Vehicle_Owner] != PlayerData[playerid][Character_Name]) return SendPlayerErrorMessage(playerid, " You do not own this vehicle, you cannot use /recyclecar!");

        if(IsPlayerInRangeOfPoint(playerid, 4.0, 2409.5278,-1426.0397,23.9829))
        {
			VehicleData[vehicleid][Vehicle_Faction] = 0;
			VehicleData[vehicleid][Vehicle_Owner] = blankstring;
			VehicleData[vehicleid][Vehicle_Used] = 0;

			VehicleData[vehicleid][Vehicle_Model] = 402;
			VehicleData[vehicleid][Vehicle_Color_1] = 0;
			VehicleData[vehicleid][Vehicle_Color_2] = 0;

			VehicleData[vehicleid][Vehicle_Spawn_X] = 0;
			VehicleData[vehicleid][Vehicle_Spawn_Y] = 0;
			VehicleData[vehicleid][Vehicle_Spawn_Z] = 0;
			VehicleData[vehicleid][Vehicle_Spawn_A] = 0;

			VehicleData[vehicleid][Vehicle_Lock] = 0;
			VehicleData[vehicleid][Vehicle_Alarm] = 0;
			VehicleData[vehicleid][Vehicle_GPS] = 0;
			VehicleData[vehicleid][Vehicle_Fuel] = 0;
			VehicleData[vehicleid][Vehicle_Type] = 0;
			VehicleData[vehicleid][Vehicle_License_Plate] = 0;

	        new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_faction` = '0', `vehicle_owner` = '', `vehicle_used` = '0', `vehicle_model` = '402', `vehicle_color_1` = '0', `vehicle_color_2` = '0', `vehicle_spawn_x` = '0', `vehicle_spawn_y` = '0', `vehicle_spawn_z` = '0', `vehicle_spawn_a` = '0', `vehicle_lock` = '0', `vehicle_alarm` = '0', `vehicle_gps` = '0', `vehicle_license_plate` = '0', `vehicle_fuel` = '0', `vehicle_type` = '0' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_ID]);
	   		mysql_tquery(connection, query);

	   		DestroyVehicle(vehicleid);
	   		
	   		if(VehicleData[vehicleid][Vehicle_Used] == 0)
	        {
	            AddStaticVehicleEx(402, 4572.7007, -1116.7518, 0.3459, 180, 1, 1, -1);

				new licenseplate[10];
				format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
				SetVehicleNumberPlate(vehicleid, licenseplate);
	        }

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just recycled your vehicle (You get $500 for recycling your vehicle)!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			PlayerData[playerid][Character_Money] += 500;
			PlayerData[playerid][Character_Total_Vehicles] --;

			printf("%s has just recycled thier vehicle", GetName(playerid));
		}
		else return SendPlayerErrorMessage(playerid, " You are not near the recycle center for vehicles!");
	}
	return 1;
}

CMD:changeownership(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    new vehicleid, targetid, ownername[50];

	    vehicleid = GetPlayerVehicleID(playerid);

		if(sscanf(params, "i", targetid))
		{
			SendPlayerServerMessage(playerid, " /changeownership [playerid]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
		    if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");
		    if(VehicleData[vehicleid][Vehicle_Owner] != PlayerData[playerid][Character_Name]) return SendPlayerErrorMessage(playerid, " You do not own this vehicle, you cannot use /changeownership!");

			ownername = GetName(targetid);
			VehicleData[vehicleid][Vehicle_Owner] = ownername;

            new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_owner` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Owner], VehicleData[vehicleid][Vehicle_ID]);
    		mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just changed ownership of your vehicle to: %s!", ownername);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			PlayerData[playerid][Character_Total_Vehicles] --;
			PlayerData[targetid][Character_Total_Vehicles] ++;
		}
	}
	return 1;
}

CMD:park(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	else
	{
	    new vehicleid;
	    new Float:vehx, Float:vehy, Float:vehz, Float:veha;

	    vehicleid = GetPlayerVehicleID(playerid);

		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");
		if(VehicleData[vehicleid][Vehicle_Owner] != PlayerData[playerid][Character_Name]) return SendPlayerErrorMessage(playerid, " You do not own this vehicle, you cannot use /park!");

		GetVehiclePos(vehicleid, vehx, vehy, vehz);
        GetVehicleZAngle(vehicleid, veha);
		VehicleData[vehicleid][Vehicle_Spawn_X] = vehx;
		VehicleData[vehicleid][Vehicle_Spawn_Y] = vehy;
		VehicleData[vehicleid][Vehicle_Spawn_Z] = vehz;
		VehicleData[vehicleid][Vehicle_Spawn_A] = veha;

        new query[2000];
        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
   		mysql_tquery(connection, query);

		new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just parked your private vehicle!");
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("%s has parked thier vehicle", GetName(playerid));
	}
	return 1;
}

CMD:engine(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid] == 1)
	    {
			new PLAYER_STATE:driver_state = GetPlayerState(playerid);
			
	        if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be inside a vehicle to use this command!");
			if(driver_state != PLAYER_STATE_DRIVER) return SendPlayerErrorMessage(playerid, " You need to be in the drivers seat to use this command!");

			new vehicleid = GetPlayerVehicleID(playerid);
			new Float:vehiclehealth;

			GetVehicleHealth(vehicleid, vehiclehealth);
			
			new string[156];
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(engine == 1)
			{
				SetVehicleParamsEx(vehicleid, false, lights, alarm, doors, bonnet, boot, objective);

			    format(string, sizeof(string), "> %s has just turned the key of their vehicle off", GetName(playerid));
	   			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

   				PlayerTextDrawSetString(playerid, SpeedBoxFuelAmount, "-");

   				KillTimer(Fuel_Timer[playerid]);
   				KillTimer(Vehicle_Timer[playerid]);

   				Fuel_Timer[playerid] = 0;
				Vehicle_Timer[playerid] = 0;

				printf("%s has turned thier vehicle off", GetName(playerid));
			}
			else
			{
			    if(vehiclehealth <= 300) return SendPlayerErrorMessage(playerid, " This vehicle is two damaged to turn on, call a mechanic!");
				else if(vehiclehealth > 300)
				{
				    SetVehicleParamsEx(vehicleid, true, lights, alarm, doors, bonnet, boot, objective);

				    format(string, sizeof(string), "> %s has just turned the key of their vehicle around and turned it on", GetName(playerid));
	   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

	   				Fuel_Timer[playerid] = SetTimerEx("FuelTimer", 10000, true);
	   				Vehicle_Timer[playerid] = SetTimerEx("VehicleTimer", 250, true, "i", playerid);

	   				printf("%s has turned thier vehicle on", GetName(playerid));
				}
			}
	    }
	}
	return 1;
}

CMD:lights(playerid, params[])
{

	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid] == 1)
	    {
	        new PLAYER_STATE:driver_state = GetPlayerState(playerid);
			
	        if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be inside a vehicle to use this command!");
			if(driver_state != PLAYER_STATE_DRIVER) return SendPlayerErrorMessage(playerid, " You need to be in the drivers seat to use this command!");
	        
			new vehicleid = GetPlayerVehicleID(playerid);
			new string[156];
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(lights == 1)
			{
			    SetVehicleParamsEx(vehicleid, engine, false, alarm, doors, bonnet, boot, objective);
			    format(string, sizeof(string), "> %s has just flicked their vehicle lights off", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has turned thier vehicle lights off", GetName(playerid));
			}
			else
			{
			    SetVehicleParamsEx(vehicleid, engine, true, alarm, doors, bonnet, boot, objective);
			    format(string, sizeof(string), "> %s has just flicked their vehicle lights on", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has turned thier vehicle lights on", GetName(playerid));
			}
	    }
	}
	return 1;
}

CMD:flash(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid] == 1)
	    {
	        new PLAYER_STATE:driver_state = GetPlayerState(playerid);
			
	        if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be inside a vehicle to use this command!");
			if(driver_state != PLAYER_STATE_DRIVER) return SendPlayerErrorMessage(playerid, " You need to be in the drivers seat to use this command!");
			
	        if(IsLSPDVehicle(playerid) || IsLSFDVehicle(playerid) || IsLSMCVehicle(playerid) || IsDudeFixVehicle(playerid) || IsElectricianVehicle(playerid))
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new string[156];
				new engine_check, lights_check, alarm_check, doors_check, bonnet_check, boot_check, objective_check;
				GetVehicleParamsEx(vehicleid, engine_check, lights_check, alarm_check, doors_check, bonnet_check, boot_check, objective_check);
	
				if(lights_check == 0) return SendPlayerErrorMessage(playerid, " You need to have your lights turned on first!");
				{
					if(VehicleFlash_Timer[vehicleid] == 0)
					{
					    VehicleFlash_Timer[vehicleid] = SetTimerEx("FlashLights", 100, true, "i", vehicleid);
					
					    format(string, sizeof(string), "> %s has just flicked their vehicle safety lights on", GetName(playerid));
		   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
		
		                printf("%s has turned thier vehicle safety lights on", GetName(playerid));
					}
					else
					{
					    KillTimer(VehicleFlash_Timer[vehicleid]);
		            	VehicleFlash_Timer[vehicleid] = 0;
		
					    format(string, sizeof(string), "> %s has just flicked their vehicle safety lights off", GetName(playerid));
		   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
		
						new VEHICLE_PANEL_STATUS:panels, VEHICLE_DOOR_STATUS:doors, VEHICLE_LIGHT_STATUS:lights, VEHICLE_TIRE_STATUS:tires;
		    			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		
						lights = VEHICLE_LIGHT_STATUS:0;
						UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		
		                printf("%s has turned thier vehicle safety lights off", GetName(playerid));
					}
				}
			}
			else return SendPlayerErrorMessage(playerid, " You are not within a vehicle that has this ability to have flashing lights!");
	    }
	}
	return 1;
}

CMD:bonnet(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid] == 1)
	    {
	        new PLAYER_STATE:driver_state = GetPlayerState(playerid);
			
	        if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be inside a vehicle to use this command!");
			if(driver_state != PLAYER_STATE_DRIVER) return SendPlayerErrorMessage(playerid, " You need to be in the drivers seat to use this command!");
	        
			new vehicleid = GetPlayerVehicleID(playerid);
			new string[156];
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(bonnet == 1)
			{
			    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, false, boot, objective);
			    format(string, sizeof(string), "> %s has just closed the front of their bonnet", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has closed thier bonnet", GetName(playerid));
			}
			else
			{
			    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, true, boot, objective);
			    format(string, sizeof(string), "> %s has just popped open the front of their bonnet", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has opened thier bonnet", GetName(playerid));
			}
	    }
	}
	return 1;
}

CMD:boot(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid] == 1)
	    {
	        new PLAYER_STATE:driver_state = GetPlayerState(playerid);
			
	        if(!IsPlayerInAnyVehicle(playerid)) return SendPlayerErrorMessage(playerid, " You need to be inside a vehicle to use this command!");
			if(driver_state != PLAYER_STATE_DRIVER) return SendPlayerErrorMessage(playerid, " You need to be in the drivers seat to use this command!");
	        
			new vehicleid = GetPlayerVehicleID(playerid);
			new string[156];
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(boot == 1)
			{
			    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, false, objective);
			    format(string, sizeof(string), "> %s has just closed the back of their vehicle", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has closed their boot", GetName(playerid));
			}
			else
			{
			    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, true, objective);
			    format(string, sizeof(string), "> %s has just popped opened the back of their vehicle", GetName(playerid));
   				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);

                printf("%s has opened their boot", GetName(playerid));
			}
	    }
	}
	return 1;
}

// FACTION COMMANDS
CMD:factions(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
	        new query[128];
		    mysql_format(connection, query, sizeof(query), "SELECT * FROM `faction_information`");
			mysql_tquery(connection, query, "OnFactionCheck", "i", playerid);
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:fstaff(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
	        new atext[50], string[256];

			SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}*** {F2F746}Online Staff{FFFFFF} ***");

	        for (new i = 0; i < MAX_PLAYERS; i++)
	        {
				if(PlayerData[i][Character_Faction] > 0)
				{
					switch(PlayerData[i][Character_Faction_Rank])
					{
					    case 1: { atext = "[Rank 1]"; }
					    case 2: { atext = "[Rank 2]"; }
					    case 3: { atext = "[Rank 3]"; }
					    case 4: { atext = "[Rank 4]"; }
					    case 5: { atext = "[Rank 5]"; }
					    case 6: { atext = "[Rank 6]"; }
					}
					
					if(IsPlayerOnDuty[playerid] == 1)
					{
					    format(string, sizeof(string), "> {F2F746}%s{FFFFFF} %s{F2F746} [On Duty]", atext, PlayerData[i][Character_Name]);
		            	SendClientMessage(playerid, COLOR_WHITE, string);
					}
					else
					{
			            format(string, sizeof(string), "> {F2F746}%s{FFFFFF} %s", atext, PlayerData[i][Character_Name]);
			            SendClientMessage(playerid, COLOR_WHITE, string);
					}
				}
	        }
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:setrankname(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction] == 0 || PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new rankid;
		new acquery[2000], value[20], dstring[2000];

		if(sscanf(params, "is[20]", rankid, value))
		{
			SendPlayerServerMessage(playerid, " /setrankname [rank id] [value] (20 characters)");
			SendPlayerServerMessage(playerid, " OPTIONS: 1 to 6 - Rank Name (6 = Owner Rank)");
		}
		else
		{
			new factionid;
			factionid = PlayerData[playerid][Character_Faction];
			
			switch(rankid)
			{
			    case 1:
			    {
			        FactionData[factionid][Faction_Rank_1] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_1` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 1 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_1]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 2:
			    {
			        FactionData[factionid][Faction_Rank_2] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_2` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 2 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_2]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 3:
			    {
			        FactionData[factionid][Faction_Rank_3] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_3` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 3 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_3]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 4:
			    {
			        FactionData[factionid][Faction_Rank_4] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_4` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 4 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_4]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 5:
			    {
			        FactionData[factionid][Faction_Rank_5] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_5` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 5 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_5]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 6:
			    {
			        FactionData[factionid][Faction_Rank_6] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_6` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated your faction (%s) Rank 6 to be (%s)", FactionData[factionid][Faction_Name], FactionData[factionid][Faction_Rank_6]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			}
		}
	}
	return 1;
}

CMD:hire(playerid, params[])
{
    if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction] == 0 || PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new dstring[256], factionname[20];
     	new targetid, factionid;

		if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /hire [playerid]");
		}
		else
  		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  		    if(PlayerData[targetid][Character_Faction] != 0) return SendPlayerErrorMessage(playerid, " You cannot hire someone who is already within another faction!");
            if(PlayerData[playerid][Character_Faction_Ban] > 0) return SendPlayerErrorMessage(playerid, " You cannot hire someone who has a faction ban. Please contact staff via forums for removal against player!");
			else
		  	{
		  	    factionid = PlayerData[playerid][Character_Faction];
		  	    factionname = FactionData[factionid][Faction_Name];

		  	    PlayerData[targetid][Character_Faction] = factionid;
				PlayerData[targetid][Character_Faction_Rank] = 1;
				
				new cquery[2000];
			    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction` = '%i', `character_faction_rank` = '1' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Faction], PlayerData[targetid][Character_Name]);
			    mysql_tquery(connection, cquery);

				format(dstring, sizeof(dstring), "> You have just been hired into faction %s!", factionname);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} You have just hired %s into the faction %s!", GetName(targetid), factionname);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} %s has just been hired into the %s!", GetName(targetid), factionname);
				SendFactionOOCMessage(factionid, COLOR_LIME, dstring);
  		    }
		}
	}
	return 1;
}

CMD:fire(playerid, params[])
{
    if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction] == 0 || PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new dstring[256], reason[100], factionname[20];
     	new targetid, factionid;

		if(sscanf(params, "is", targetid, reason))
		{
		    SendPlayerServerMessage(playerid, " /fire [playerid] [reason]");
		}
		else
  		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  		    if(PlayerData[playerid][Character_Faction] != PlayerData[targetid][Character_Faction]) return SendPlayerErrorMessage(playerid, " You cannot fire someone who isn't within your faction!");
			else
		  	{
		  	    factionid = PlayerData[playerid][Character_Faction];
		  	    factionname = FactionData[factionid][Faction_Name];
		  	    
		  	    PlayerData[targetid][Character_Faction] = 0;
				PlayerData[targetid][Character_Faction_Rank] = 0;
				
				new cquery[2000];
			    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction` = '0', `character_faction_rank` = '0' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Faction], PlayerData[targetid][Character_Name]);
			    mysql_tquery(connection, cquery);

				format(dstring, sizeof(dstring), "> You have just been fired from faction %s!", factionname);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} You have just fired %s from the faction %s!", GetName(targetid), factionname);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} %s has just been fired from the organisation!", GetName(targetid));
				SendFactionOOCMessage(factionid, COLOR_LIME, dstring);
  		    }
		}
	}
	return 1;
}

CMD:setrank(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction] == 0 || PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature. You are not a faction leader!");
	{
     	new dstring[256], rankname[20];
     	new rankid, targetid, factionid;

		if(sscanf(params, "ii", targetid, rankid))
		{
		    SendPlayerServerMessage(playerid, " /setrank [playerid] [new rank (1-5)]");
		}
		else
  		{
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot set the rank of yourself, you need another rank 6 member!");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  		    if(PlayerData[playerid][Character_Faction] != PlayerData[targetid][Character_Faction]) return SendPlayerErrorMessage(playerid, " You cannot change a rank of a player that is not in your faction!");
			if(rankid < 1 || rankid > 5) return SendPlayerErrorMessage(playerid, " You need to give a rank level between 1 and 5!");
			else
		  	{
		  	    factionid = PlayerData[playerid][Character_Faction];
				PlayerData[targetid][Character_Faction_Rank] = rankid;
				
				if(PlayerData[targetid][Character_Faction_Rank] == 1)
				{
					format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_1]);
				}
				else if(PlayerData[targetid][Character_Faction_Rank] == 2)
				{
				    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_2]);
				}
				else if(PlayerData[targetid][Character_Faction_Rank] == 3)
				{
				    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_3]);
				}
				else if(PlayerData[targetid][Character_Faction_Rank] == 4)
				{
				    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_4]);
				}
				else if(PlayerData[targetid][Character_Faction_Rank] == 5)
				{
				    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_5]);
				}
				else if(PlayerData[targetid][Character_Faction_Rank] == 6)
				{
				    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_6]);
				}
				
				new cquery[2000];
			    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_rank` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Faction_Rank], PlayerData[targetid][Character_Name]);
			    mysql_tquery(connection, cquery);

				format(dstring, sizeof(dstring), "> You have just been given the new rank of %s!", rankname);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
				
				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} You have just given %s the new rank of %s!", GetName(targetid), rankname);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
  		    }
		}
	}
	return 1;
}

CMD:factionchat(playerid, params[]) return cmd_fchat(playerid, params);
CMD:fchat(playerid, params[])
{
    if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Faction] == 0) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
		{
		    new factionid;
	    	new dstring[150], playername[MAX_PLAYER_NAME];
	    	new rankname[20];
	    	
		    if(isnull(params)) return SendPlayerServerMessage(playerid, " /f(action)chat [message]");
			else
			{
				if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You are currently muted and cannot use this chat!");
				else
				{
			    	factionid = PlayerData[playerid][Character_Faction];
					playername = GetName(playerid);
					
					if(PlayerData[playerid][Character_Faction_Rank] == 1)
					{
						format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_1]);
					}
					else if(PlayerData[playerid][Character_Faction_Rank] == 2)
					{
					    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_2]);
					}
					else if(PlayerData[playerid][Character_Faction_Rank] == 3)
					{
					    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_3]);
					}
					else if(PlayerData[playerid][Character_Faction_Rank] == 4)
					{
					    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_4]);
					}
					else if(PlayerData[playerid][Character_Faction_Rank] == 5)
					{
					    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_5]);
					}
					else if(PlayerData[playerid][Character_Faction_Rank] == 6)
					{
					    format(rankname, sizeof(rankname), "%s", FactionData[factionid][Faction_Rank_6]);
					}
					
					format(dstring, sizeof(dstring), "((Faction OOC %s %s: %s ))", rankname, playername, params);
					SendFactionOOCMessage(factionid, COLOR_LIME, dstring);
				}
			}
		}
	}
	return 1;
}

CMD:quitjob(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Job] == 0) return SendPlayerErrorMessage(playerid, " You cannot quit a job at this point in time. Reason: You are not apart of any job!");
		else		
		{
		    new dstring[256];

			PlayerData[playerid][Character_Job] = 0;

			new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_job` = '0' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

			format(dstring, sizeof(dstring), "> You have just left your current job");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("QUIT JOB [Completed] | %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:joinjob(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Job] > 0) return SendPlayerErrorMessage(playerid, " You are already apart of a job, you cannot rejoin/join any new job at this time!");
    if(PlayerData[playerid][Character_Job] == 0)
	{
	    new jobid;
	    new dstring[256];

		if(IsPlayerInRangeOfPoint(playerid, 3.0, 2102.2109, -1789.1084, 13.5547)) // PIZZA JOB LOCATION
		{
		    jobid = 1;
		    PlayerData[playerid][Character_Job] = jobid;
		    
		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_job` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Job], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);
		    
		    format(dstring, sizeof(dstring), "> You have just joined the Pizza Delivery service. Use /startjob or /stopjob at the icon to being");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("JOIN PIZZA JOB [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2201.1582,-1974.1382,13.5576)) // Garbage job LOCATION
		{
		    jobid = 2;
		    PlayerData[playerid][Character_Job] = jobid;
		    
		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_job` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Job], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);
		    
		    format(dstring, sizeof(dstring), "> You have just joined the Garbage Collection service. Use /startjob or /stopjob at the icon to being");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("JOIN GARBAGE JOB [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 992.1449,-1454.0868,13.5469)) // Electrician Job LOCATION
		{
		    jobid = 3;
		    PlayerData[playerid][Character_Job] = jobid;
		    
		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_job` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Job], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);
		    
		    format(dstring, sizeof(dstring), "> You have just joined the Electrician Guild. Use /startjob or /stopjob at the icon to being");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("JOIN ELECTRICIAN JOB [Completed] | %s", GetName(playerid));
		}
		else return SendPlayerErrorMessage(playerid, " You are not near any job pickup that allows this command!");
	}
	return 1;
}

CMD:quitfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Faction] == 0) return SendPlayerErrorMessage(playerid, " You cannot quit a faction at this point in time. Reason: You are not apart of any faction!");
		{
		    if(PlayerData[playerid][Character_Owns_Faction] == 1) return SendPlayerErrorMessage(playerid, " You cannot quit a faction at this point in time. Reason: You need to sell your faction!");
		    else
		    {
			    new dstring[256];
				new factionid;

				factionid = PlayerData[playerid][Character_Faction];

			    PlayerData[playerid][Character_Faction] = 0;
			    PlayerData[playerid][Character_Faction_Rank] = 0;

			    new cquery[2000];
			    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction` = '0', `character_faction_rank` = '0' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Faction], PlayerData[playerid][Character_Name]);
				mysql_tquery(connection, cquery);

			    format(dstring, sizeof(dstring), "> You have just left the %s faction. We are sorry to see you leave!", FactionData[factionid][Faction_Name]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

			    format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just left the faction!", GetName(playerid));
				SendFactionOOCMessage(factionid, COLOR_RED, dstring);

				printf("QUITFACTION [Completed] | %s", GetName(playerid));
			}
		}
	}
	return 1;
}

CMD:cancelrequest(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Faction_Join_Request] == 0) return SendPlayerErrorMessage(playerid, " You are not currently awaiting approval for a faction!");
		{
		    new dstring[256];
			
			PlayerData[playerid][Character_Faction_Join_Request] = 0;

			new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

			format(dstring, sizeof(dstring), "> You have just cancelled your faction application!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("CANCELREQUEST [Completed] | %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:joinfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction] > 0) return SendPlayerErrorMessage(playerid, " You are already apart of a faction, you cannot rejoin/join any new factions at this time!");
 	if(PlayerData[playerid][Character_Faction_Ban] > 0) return SendPlayerErrorMessage(playerid, " You cannot join a faction as you are currently, faction banned. Request ban removal via forums!");
	if(PlayerData[playerid][Character_Faction_Join_Request] > 0) return SendPlayerErrorMessage(playerid, " You have already attempted to join another faction, please wait or /cancelrequest");
    if(PlayerData[playerid][Character_Faction] == 0)
	{
	    new factionid;
	    new dstring[256];

		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1544.5784,-1670.9464,13.5587)) // LSPD JOIN LOCATION
		{
		    factionid = 1;
		    PlayerData[playerid][Character_Faction_Join_Request] = 1;
		    
		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);
		    
		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
		    
			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;
		    
		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 1 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}
		    
		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the LSPD");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1755.8239,-1720.1548,13.3870)) // LSFD JOIN LOCATION
		{
		    factionid = 2;
		    PlayerData[playerid][Character_Faction_Join_Request] = 2;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 2 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the LSFD");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1996.7914,-1442.0536,13.5677)) // LSMC JOIN LOCATION
		{
		    factionid = 3;
		    PlayerData[playerid][Character_Faction_Join_Request] = 3;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 3 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the LSMC");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 4) // BANK JOIN LOCATION
		{
		    factionid = 4;
		    PlayerData[playerid][Character_Faction_Join_Request] = 4;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 4 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Bank");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 5) // TOW CO JOIN LOCATION
		{
		    factionid = 5;
		    PlayerData[playerid][Character_Faction_Join_Request] = 5;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 5 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Tow Co");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 6) // Taxi Co JOIN LOCATION
		{
		    factionid = 6;
		    PlayerData[playerid][Character_Faction_Join_Request] = 6;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 6 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Taxi Co");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 7) // Truck Co JOIN LOCATION
		{
		    factionid = 7;
		    PlayerData[playerid][Character_Faction_Join_Request] = 7;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 7 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Truck Co");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 8) // Dudefix JOIN LOCATION
		{
		    factionid = 8;
		    PlayerData[playerid][Character_Faction_Join_Request] = 8;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 8 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Dudefix");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 9) // Mechanic JOIN LOCATION
		{
		    factionid = 9;
		    PlayerData[playerid][Character_Faction_Join_Request] = 9;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 9 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Mechanic Shop");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 10) // Grove Gang JOIN LOCATION
		{
		    factionid = 10;
		    PlayerData[playerid][Character_Faction_Join_Request] = 10;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 10 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Grove Gang");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 11) // La Familia Gang JOIN LOCATION
		{
		    factionid = 11;
		    PlayerData[playerid][Character_Faction_Join_Request] = 11;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 11 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the La Familia Gang");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else if(IsPlayerNearFactionIcon(playerid) && PlayerAtFactionID[playerid] == 12) // Hells Gang JOIN LOCATION
		{
		    factionid = 12;
		    PlayerData[playerid][Character_Faction_Join_Request] = 12;

		    new cquery[500];
		    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction_join_request` = '%i' WHERE `character_name` = '%e'", PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
			mysql_tquery(connection, cquery);

		    format(dstring, sizeof(dstring), "> You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			FactionData[factionid][Faction_Join_Requests] = FactionData[factionid][Faction_Join_Requests]+1;

		    for(new t = 0; t < MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 12 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT]:{FFFFFF} %s has just applied [in-game] to join the faction. /acceptrequest or /rejectrequest the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}

		    format(dstring, sizeof(dstring), "[APPLICATION ALERT]:{FFFFFF} You have just applied to be apart of the Hells Angels Gang");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("JOINFACTION [Completed] | %s", GetName(playerid));
		}
		else return SendPlayerErrorMessage(playerid, " You are not near any faction pickup that allows this command!");
	}
	return 1;
}

CMD:requests(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new dstring[256];
	    new count = 0;
	    
	    format(dstring, sizeof(dstring), "---------- [FACTION REQUESTS] ----------");
     	SendClientMessage(playerid, COLOR_YELLOW, dstring);
	    
	    for(new t = 0; t < MAX_PLAYERS; t++)
		{
	    	if(PlayerData[t][Character_Faction_Join_Request] == PlayerData[playerid][Character_Faction])
		    {
		        format(dstring, sizeof(dstring), "{FFFFFF}Player ID: %i | Name: %s | Current Faction: %s", t, PlayerData[t][Character_Name],PlayerData[t][Character_Faction]);
		        SendClientMessage(playerid, COLOR_YELLOW, dstring);
		        count = count++;
			}
		}
		
		if(count == 0)
		{
		    format(dstring, sizeof(dstring), "{FFFFFF}There are no online players with any faction requests at this time!"); // BUG this displays when there are faction joining requests
     		SendClientMessage(playerid, COLOR_YELLOW, dstring);
		}
		
		printf("FACTIONREQUESTS [Completed] | %s", GetName(playerid));
	}
	return 1;
}

CMD:acceptrequest(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid, factionid;
	    new dstring[256];
	    
	    if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /acceptrequest [playerid]");
		}
		else
  		{
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot accept yourself into the faction!");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  		    if(PlayerData[targetid][Character_Faction_Join_Request] == PlayerData[playerid][Character_Faction])
  		    {
				factionid = PlayerData[playerid][Character_Faction];

	  		    PlayerData[targetid][Character_Faction_Join_Request] = 0;
	  		    PlayerData[targetid][Character_Faction] = factionid;
	  		    PlayerData[targetid][Character_Faction_Rank] = 1;

	  		    new cquery[2000];
	   			mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction` = '%i', `character_faction_rank` = '1', `character_faction_join_request` = '0' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Faction], PlayerData[targetid][Character_Name]);
				mysql_tquery(connection, cquery);

	  		    FactionData[factionid][Faction_Join_Requests] --;

			    format(dstring, sizeof(dstring), "> You have just been accepted into faction %s!", FactionData[factionid][Faction_Name]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} You have just hired %s into the faction %s!", GetName(targetid), FactionData[factionid][Faction_Name]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} %s has just been hired into the %s!", GetName(targetid), FactionData[factionid][Faction_Name]);
				SendFactionOOCMessage(factionid, COLOR_LIME, dstring);

				printf("ACCEPTREQUEST [Completed] | %s", GetName(playerid));
			}
			else SendPlayerErrorMessage(playerid, " This player does not have an application with your faction!");
  		}
	}
	return 1;
}

CMD:rejectrequest(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	if(PlayerData[playerid][Character_Faction_Rank] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid, factionid;
	    new dstring[256];

	    if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /rejectrequest [playerid]");
		}
		else
  		{
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot reject yourself from the faction!");
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
  		    if(PlayerData[targetid][Character_Faction_Join_Request] == PlayerData[playerid][Character_Faction])
  		    {
				factionid = PlayerData[playerid][Character_Faction];

	  		    PlayerData[targetid][Character_Faction_Join_Request] = 0;
	  		    PlayerData[targetid][Character_Faction] = 0;
	  		    PlayerData[targetid][Character_Faction_Rank] = 0;

	  		    new cquery[2000];
				mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_faction` = '0', `character_faction_rank` = '0', `character_faction_join_request` = '0' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Name]);
				mysql_tquery(connection, cquery);

	  		    FactionData[factionid][Faction_Join_Requests] --;

			    format(dstring, sizeof(dstring), "> You have been rejected from joining faction %s!", FactionData[factionid][Faction_Name]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "[FACTION UPDATE]:{FFFFFF} You have just rejected %s into the faction %s!", GetName(targetid), FactionData[factionid][Faction_Name]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);

				printf("REJECTREQUEST [Completed] | %s", GetName(playerid));
            }
			else SendPlayerErrorMessage(playerid, " This player does not have an application with your faction!");
  		}
	}
	return 1;
}

// BUSINESS COMMANDS

CMD:sellbusiness(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new bdoorid;

		namestring = "";

		if(!IsPlayerNearBusinessDoor(playerid) || PlayerAtBusinessID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a business entry point!");

        bdoorid = PlayerAtBusinessID[playerid];
		if(bdoorid != 0 && BusinessData[bdoorid][Business_Owner] != PlayerData[playerid][Character_Name])
		{
		    SendPlayerErrorMessage(playerid, " You cannot sell a business that you do not own, you can check who owns properties at the city council!");
		}
		else
  		{
		    DestroyDynamicPickup(BusinessData[bdoorid][Business_Pickup_ID_Outside]);
		    BusinessData[bdoorid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19523, 1,BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]-0.3, -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_owner` = '', `business_sold` = '0' WHERE `business_id` = '%i' LIMIT 1", bdoorid);
			mysql_tquery(connection, equery);

			BusinessData[bdoorid][Business_Owner] = namestring;
			BusinessData[bdoorid][Business_Sold] = 0;
			PlayerData[playerid][Character_Money] += BusinessData[bdoorid][Business_Price_Money];
			PlayerData[playerid][Character_Business_ID] = 0;
			PlayerData[playerid][Character_Total_Businesses] --;
			
			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_businesses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Businesses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just sold your business %s for $%d", BusinessData[bdoorid][Business_Name], BusinessData[bdoorid][Business_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			PlayerAtBusinessID[playerid] = 0;
		}
	}
	return 1;
}

CMD:buybusiness(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new bdoorid;

		namestring = GetName(playerid);
		
  		if(!IsPlayerNearBusinessDoor(playerid) || PlayerAtBusinessID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a business entry point!");
		if(PlayerData[playerid][Character_Total_Businesses] == MAX_PLAYER_BUSINESSES) return format(dstring, sizeof(dstring), "[ERROR]: {FFFFFF}You cannot purchase more than %i businesses in this community!", MAX_PLAYER_BUSINESSES); SendClientMessage(playerid, COLOR_PINK, dstring);

		bdoorid = PlayerAtBusinessID[playerid];
 	    if(bdoorid != 0 && BusinessData[bdoorid][Business_Owner] != PlayerData[playerid][Character_Name] && BusinessData[bdoorid][Business_Sold] == 1)
		{
		    SendPlayerErrorMessage(playerid, " You cannot purchase a business that someone else already owns! You can view all ownerships of properties, down at the city council!");
		}
		if(PlayerDefaultPayment[playerid] == 1)
		{
		    if(PlayerData[playerid][Character_Money] < BusinessData[bdoorid][Business_Price_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money in hand to purchase this business!");

			DestroyDynamicPickup(BusinessData[bdoorid][Business_Pickup_ID_Outside]);
		    BusinessData[bdoorid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]+0.1, -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_owner` = '%e', `business_sold` = '1' WHERE `business_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], bdoorid);
			mysql_tquery(connection, equery);

			BusinessData[bdoorid][Business_Owner] = namestring;
			BusinessData[bdoorid][Business_Sold] = 1;
			PlayerData[playerid][Character_Money] -= BusinessData[bdoorid][Business_Price_Money];
			PlayerData[playerid][Character_Business_ID] = bdoorid;
			PlayerData[playerid][Character_Total_Businesses] ++;
				
			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_businesses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Businesses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just purchased business %s for $%d", BusinessData[bdoorid][Business_Name], BusinessData[bdoorid][Business_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			PlayerAtBusinessID[playerid] = 0;
		}
		else if(PlayerDefaultPayment[playerid] == 2)
		{
		    if(PlayerData[playerid][Character_Coins] < BusinessData[bdoorid][Business_Price_Coins]) return SendPlayerErrorMessage(playerid, " You do not have enough coins to purchase this property!");

			DestroyDynamicPickup(BusinessData[bdoorid][Business_Pickup_ID_Outside]);
		    BusinessData[bdoorid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,BusinessData[bdoorid][Business_Outside_X], BusinessData[bdoorid][Business_Outside_Y], BusinessData[bdoorid][Business_Outside_Z]+0.1, -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_owner` = '%e', `business_sold` = '1' WHERE `business_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], bdoorid);
			mysql_tquery(connection, equery);

			BusinessData[bdoorid][Business_Owner] = namestring;
			BusinessData[bdoorid][Business_Sold] = 1;
			PlayerData[playerid][Character_Coins] -= BusinessData[bdoorid][Business_Price_Coins];
			PlayerData[playerid][Character_Business_ID] = bdoorid;
			PlayerData[playerid][Character_Total_Businesses] ++;

			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_businesses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Businesses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just purchased business %s for %d coins", BusinessData[bdoorid][Business_Name], BusinessData[bdoorid][Business_Price_Coins]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);

			PlayerAtBusinessID[playerid] = 0;
		}
	}
	return 1;
}

// PROPERTY COMMANDS

CMD:gate(playerid, params[])
{
    if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10, 1771.97620, -1697.25159, 13.96490) && PlayerData[playerid][Character_Faction] == 2)
	    {
	        if(LSFDGateLeftOpen == true)
	        {
	            MoveDynamicObject(LSFDGateLeft, 1771.97620, -1697.25159, 13.96490, 1, 0.00000, 0.00000, 90.00000);
	            LSFDGateLeftOpen = false;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the garage door", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(LSFDGateLeftOpen == false)
	        {
	            MoveDynamicObject(LSFDGateLeft, 1770.27625, -1697.25159, 15.50700, 1, 90.00000, 0.00000, 90.00000);
	            LSFDGateLeftOpen = true;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the garage door", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 10, 1771.98523, -1715.84265, 13.96486) && PlayerData[playerid][Character_Faction] == 2)
	    {
	        if(LSFDGateRightOpen == true)
	        {
	            MoveDynamicObject(LSFDGateRight, 1771.98523, -1715.84265, 13.96486, 1, 0.00000, 0.00000, 90.00000);
	            LSFDGateRightOpen = false;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the garage door", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(LSFDGateRightOpen == false)
	        {
	            MoveDynamicObject(LSFDGateRight, 1770.27625, -1715.84265, 15.50700, 1, 90.00000, 0.00000, 90.00000);
	            LSFDGateRightOpen = true;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the garage door", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 10, 1771.73315, -1687.46606, 14.04362) && PlayerData[playerid][Character_Faction] == 2)
	    {
	        if(LSFDGateBackOpen == true)
	        {
	            MoveDynamicObject(LSFDGateBack, 1771.73315, -1687.46606, 14.04362, 1, 0.00000, 0.00000, 270.00000);
	            LSFDGateBackOpen = false;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(LSFDGateBackOpen == false)
	        {
	            MoveDynamicObject(LSFDGateBack, 1767.36108, -1691.82092, 14.04360, 1, 0.0000, 0.00000, 360.00000);
	            LSFDGateBackOpen = true;
	            
	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 15, 2073.19141, -1869.90784, 14.24228) && PlayerData[playerid][Character_Faction] == 9)
	    {
	        if(MechanicFrontGateOpen == true)
	        {
	            MoveDynamicObject(MechanicFrontGate, 2073.19141, -1869.90784, 14.24228, 2, 0.00000, 0.00000, 90.00000);
	            MechanicFrontGateOpen = false;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(MechanicFrontGateOpen == false)
	        {
	            MoveDynamicObject(MechanicFrontGate, 2073.19141, -1849.89001, 14.24230, 2, 0.00000, 0.00000, 90.00000);
	            MechanicFrontGateOpen = true;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 15, 1537.10388, -1451.24597, 15.92345) && PlayerData[playerid][Character_Faction] == 5)
	    {
	        if(TowGateOpen == true)
	        {
	            MoveDynamicObject(TowGate, 1537.10388, -1451.24597, 15.92345, 2, 0.00000, 0.00000, 180.00000);
	            TowGateOpen = false;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(TowGateOpen == false)
	        {
	            MoveDynamicObject(TowGate, 1543.57214, -1451.24622, 15.92345, 2, 0.00000, 0.00000, 180.00000);
	            TowGateOpen = true;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 15, 1361.66724, -1467.49048, 13.20197) && PlayerData[playerid][Character_Faction] == 1 || IsPlayerInRangeOfPoint(playerid, 15, 1361.66724, -1467.49048, 13.20197) && PlayerData[playerid][Character_Faction] == 5)
	    {
	        if(JunkYardGateOpen == true)
	        {
	            MoveDynamicObject(JunkYardGate, 1361.66724, -1467.49048, 13.20197, 2, 0.00000, 0.00000, 75);
	            JunkYardGateOpen = false;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and closes the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	        else if(JunkYardGateOpen == false)
	        {
	            MoveDynamicObject(JunkYardGate, 1363.78271, -1459.61755, 13.20197, 2, 0.00000, 0.00000, 75);
	            JunkYardGateOpen = true;

	            new string[256];
		        format(string, sizeof(string), "> %s pulls out their remote and opens the gate", GetName(playerid));
		   		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, string);
	        }
	    }
	}
	return 1;
}

CMD:alarm(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		if(IsPlayerNearHouseDoor(playerid) && PlayerAtHouseID[playerid] != 0)
		{
	     	new namestring[50], dstring[256], equery[2000], string[256];
	     	new hdoorid;
	
			namestring = "";
	
	        hdoorid = PlayerAtHouseID[playerid];
			if(hdoorid != 0 && HouseData[hdoorid][House_Owner] != PlayerData[playerid][Character_Name])
			{
			    SendPlayerErrorMessage(playerid, " You cannot alarm a property that you do not own!");
			}
			else
	  		{
			 	if(HouseData[hdoorid][House_Alarm] == 0) return SendPlayerErrorMessage(playerid, " Your house doesn't have an alarm!");
				else
				{
					if(HouseData[hdoorid][House_Alarm_Active] == 0)
					{
						mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_alarm_active` = 1 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
						mysql_tquery(connection, equery);
						
						HouseData[hdoorid][House_Alarm_Active] = 1;
			
						format(string, sizeof(string), "> %s enters in their alarm pin on the house", GetName(playerid));
				   		SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
				
						format(dstring, sizeof(dstring), "> You have just turned your house alarm on");
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
						
						PlayerAtHouseID[playerid] = 0;
					}
					else if(HouseData[hdoorid][House_Alarm_Active] == 1)
					{
						mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_alarm_active` = 0 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
						mysql_tquery(connection, equery);
						
						HouseData[hdoorid][House_Alarm_Active] = 0; 
						
						format(string, sizeof(string), "> %s enters in their alarm pin on the house", GetName(playerid));
				   		SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
			
						format(dstring, sizeof(dstring), "> You have just turned your house alarm off");
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
						
						PlayerAtHouseID[playerid] = 0;
					}
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You are not standing near anything that can be alarmed!");
	}
	return 1;
}

CMD:lock(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		if(IsPlayerNearHouseDoor(playerid) && PlayerAtHouseID[playerid] != 0)
		{
	     	new namestring[50], dstring[256], equery[2000], string[256];
	     	new hdoorid;
	
			namestring = "";
			
	        hdoorid = PlayerAtHouseID[playerid];
			if(hdoorid != 0 && HouseData[hdoorid][House_Owner] != PlayerData[playerid][Character_Name])
			{
			    SendPlayerErrorMessage(playerid, " You cannot lock a property that you do not own!");
			}
			else
	  		{
			 	if(HouseData[hdoorid][House_Lock] == 0) return SendPlayerErrorMessage(playerid, " Your house doesn't have a lock!");
				else
				{
					if(HouseData[hdoorid][House_Lock_Active] == 0)
					{
						mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_lock_active` = 1 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
						mysql_tquery(connection, equery);
						
						HouseData[hdoorid][House_Lock_Active] = 1;
			
						format(string, sizeof(string), "> %s places their key into the hole and locks the door", GetName(playerid));
				   		SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
				
						format(dstring, sizeof(dstring), "> You have just locked your house");
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
						
						PlayerAtHouseID[playerid] = 0;
					}
					else if(HouseData[hdoorid][House_Lock_Active] == 1)
					{
						mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_lock_active` = 0 WHERE `house_id` = '%i' LIMIT 1", hdoorid);
						mysql_tquery(connection, equery);
						
						HouseData[hdoorid][House_Lock_Active] = 0; 
						
						format(string, sizeof(string), "> %s places their key into the hole and unlocks the door", GetName(playerid));
				   		SendNearbyMessage(playerid,30.0, COLOR_PURPLE, string);
				
						format(dstring, sizeof(dstring), "> You have just unlocked your house");
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
						
						PlayerAtHouseID[playerid] = 0;
					}
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You are not standing near anything that can be locked!");
	}
	return 1;
}

CMD:sellproperty(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new hdoorid;

		namestring = "";

		if(!IsPlayerNearHouseDoor(playerid) || PlayerAtHouseID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a house front door!");

        hdoorid = PlayerAtHouseID[playerid];
		if(hdoorid != 0 && HouseData[hdoorid][House_Owner] != PlayerData[playerid][Character_Name])
		{
		    SendPlayerErrorMessage(playerid, " You cannot sell a property that you do not own, you can check who owns properties at the city council!");
		}
		else
  		{
		    DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
		    HouseData[hdoorid][House_Pickup_ID_Outside] = CreateDynamicPickup(1273, 1,HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z], -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '', `house_sold` = '0', `house_lock` = '0', `house_alarm` = '0', `house_lock_active` = '0', `house_alarm_active` = '0' WHERE `house_id` = '%i' LIMIT 1", hdoorid);
			mysql_tquery(connection, equery);

			HouseData[hdoorid][House_Owner] = namestring;
			HouseData[hdoorid][House_Sold] = 0;
			HouseData[hdoorid][House_Lock] = 0;
			HouseData[hdoorid][House_Lock_Active] = 0;
			HouseData[hdoorid][House_Alarm] = 0;
			HouseData[hdoorid][House_Alarm_Active] = 0;
			
			PlayerData[playerid][Character_Money] += HouseData[hdoorid][House_Price_Money];
			PlayerData[playerid][Character_House_ID] = 0;
			PlayerData[playerid][Character_Total_Houses] --;
			
			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_houses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Houses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just sold your house %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			PlayerAtHouseID[playerid] = 0;
		}
	}
	return 1;
}

CMD:buyproperty(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new hdoorid;
     	
		namestring = GetName(playerid);
		
		if(!IsPlayerNearHouseDoor(playerid) || PlayerAtHouseID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a house front door!");
		if(PlayerData[playerid][Character_Total_Houses] == MAX_PLAYER_HOUSES) return format(dstring, sizeof(dstring), "[ERROR]: {FFFFFF}You cannot purchase more than %i houses in this community!", MAX_PLAYER_HOUSES); SendClientMessage(playerid, COLOR_PINK, dstring);
			
		hdoorid = PlayerAtHouseID[playerid];
	    if(hdoorid != 0 && HouseData[hdoorid][House_Owner] != PlayerData[playerid][Character_Name] && HouseData[hdoorid][House_Sold] == 1)
		{
		    SendPlayerErrorMessage(playerid, " You cannot purchase a property that someone else already owns! You can view all ownerships of properties, down at the city council!");
		}
		if(PlayerDefaultPayment[playerid] == 1)
		{
		    if(PlayerData[playerid][Character_Money] < HouseData[hdoorid][House_Price_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money in hand to purchase this property!");

			DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
		    HouseData[hdoorid][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z], -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '%e', `house_sold` = '1' WHERE `house_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], hdoorid);
			mysql_tquery(connection, equery);

			HouseData[hdoorid][House_Owner] = namestring;
			HouseData[hdoorid][House_Sold] = 1;
			PlayerData[playerid][Character_Money] -= HouseData[hdoorid][House_Price_Money];
			PlayerData[playerid][Character_House_ID] = hdoorid;
			PlayerData[playerid][Character_Total_Houses] ++;
				
			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_houses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Houses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just purchased property %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			PlayerAtHouseID[playerid] = 0;
		}
		else if(PlayerDefaultPayment[playerid] == 2)
		{
		    if(PlayerData[playerid][Character_Coins] < HouseData[hdoorid][House_Price_Coins]) return SendPlayerErrorMessage(playerid, " You do not have enough coins to purchase this property!");

			DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
		    HouseData[hdoorid][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z], -1);

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '%e', `house_sold` = '1' WHERE `house_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], hdoorid);
			mysql_tquery(connection, equery);

			HouseData[hdoorid][House_Owner] = namestring;
			HouseData[hdoorid][House_Sold] = 1;
			PlayerData[playerid][Character_Coins] -= HouseData[hdoorid][House_Price_Coins];
			PlayerData[playerid][Character_House_ID] = hdoorid;
			PlayerData[playerid][Character_Total_Houses] ++;
				
			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_total_houses` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Total_Houses], GetName(playerid));
			mysql_tquery(connection, equery);

			format(dstring, sizeof(dstring), "> You have just purchased property %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Coins]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			PlayerAtHouseID[playerid] = 0;
		}
	}
	return 1;
}

CMD:sellfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new ficonid;

		namestring = "";

		if(!IsPlayerNearFactionIcon(playerid) || PlayerAtFactionID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a faction icon!");

        ficonid = PlayerAtFactionID[playerid];
		printf("[Faction Sell] %s is standing near faciton id: %d", GetName(playerid), ficonid);

        if(FactionData[ficonid][Faction_Sold] == 3) return SendPlayerErrorMessage(playerid, " You cannot sell a government owned faction!");
		if(FactionData[ficonid][Faction_Sold] == 0) return SendPlayerErrorMessage(playerid, " You cannot sell a faction that isn't owned!");
		if(ficonid != 0 && FactionData[ficonid][Faction_Owner] != PlayerData[playerid][Character_Name])
		{
		    return SendPlayerErrorMessage(playerid, " You cannot sell a faction that someone else owns! You can view all ownerships of factions, down at the city council!");
		}
		else
  		{
		    mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_owner` = '', `faction_sold` = '0' WHERE `faction_id` = '%i' LIMIT 1", ficonid);
			mysql_tquery(connection, equery);

			FactionData[ficonid][Faction_Owner] = namestring;
			FactionData[ficonid][Faction_Sold] = 0;

			PlayerData[playerid][Character_Money] += FactionData[ficonid][Faction_Price_Money];

			format(dstring, sizeof(dstring), "> You have just sold faction %s for $%d", FactionData[ficonid][Faction_Name], FactionData[ficonid][Faction_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			PlayerData[playerid][Character_Owns_Faction] --;
			PlayerData[playerid][Character_Faction] = 0;
			PlayerData[playerid][Character_Faction_Rank] = 0;

			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_owns_faction` = '0', `character_faction` = '0', `character_faction_rank` = '0' WHERE `character_name` = '%e' LIMIT 1", GetName(playerid));
			mysql_tquery(connection, equery);
			
			printf("[Faction Sell] %s has just sold faction id: %d", GetName(playerid), ficonid);
			
			PlayerAtFactionID[playerid] = 0;
		}
	}
	return 1;
}

CMD:buyfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
     	new namestring[50], dstring[256], equery[2000];
     	new ficonid;

		namestring = GetName(playerid);

  		if(!IsPlayerNearFactionIcon(playerid) || PlayerAtFactionID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a faction icon!");

		ficonid = PlayerAtFactionID[playerid];
		printf("[Faction Buy] %s is standing near faciton id: %d", GetName(playerid), ficonid);
			
		if(FactionData[ficonid][Faction_Sold] == 3) return SendPlayerErrorMessage(playerid, " You cannot purchase a government owned faction!");
		if(FactionData[ficonid][Faction_Sold] == 1) return SendPlayerErrorMessage(playerid, " You cannot purchase a faction that is already owned!");
		if(PlayerData[playerid][Character_Owns_Faction] > 0) return SendPlayerErrorMessage(playerid, " You cannot own more than one faction!");

		if(PlayerDefaultPayment[playerid] == 1)
		{
		    if(PlayerData[playerid][Character_Money] < FactionData[ficonid][Faction_Price_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money in hand to purchase this faction!");

     		mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_owner` = '%e', `faction_sold` = '1' WHERE `faction_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], ficonid);
			mysql_tquery(connection, equery);

			FactionData[ficonid][Faction_Owner] = namestring;
			FactionData[ficonid][Faction_Sold] = 1;

			PlayerData[playerid][Character_Money] -= FactionData[ficonid][Faction_Price_Money];

			format(dstring, sizeof(dstring), "> You have just purchased faction %s for $%d", FactionData[ficonid][Faction_Name], FactionData[ficonid][Faction_Price_Money]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			PlayerData[playerid][Character_Owns_Faction] ++;
			PlayerData[playerid][Character_Faction] = ficonid;
			PlayerData[playerid][Character_Faction_Rank] = 6;

			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_owns_faction` = '%i', `character_faction` = '%i', `character_faction_rank` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Owns_Faction], PlayerData[playerid][Character_Faction], PlayerData[playerid][Character_Faction_Rank], GetName(playerid));
			mysql_tquery(connection, equery);
				
			printf("[Faction Buy] %s has just purhcased faction id: %d", GetName(playerid), ficonid);

			PlayerAtFactionID[playerid] = 0;
		}
		else if(PlayerDefaultPayment[playerid] == 2)
		{
		    if(PlayerData[playerid][Character_Coins] < FactionData[ficonid][Faction_Price_Coins]) return SendPlayerErrorMessage(playerid, " You do not have enough coins to purchase this faction!");

			mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_owner` = '%e', `faction_sold` = '1' WHERE `faction_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], ficonid);
			mysql_tquery(connection, equery);

			FactionData[ficonid][Faction_Owner] = namestring;
			FactionData[ficonid][Faction_Sold] = 1;

			PlayerData[playerid][Character_Coins] -= FactionData[ficonid][Faction_Price_Coins];

			format(dstring, sizeof(dstring), "> You have just purchased faction %s for %d coins", FactionData[ficonid][Faction_Name], FactionData[ficonid][Faction_Price_Coins]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
			PlayerData[playerid][Character_Owns_Faction] ++;
			PlayerData[playerid][Character_Faction] = ficonid;
			PlayerData[playerid][Character_Faction_Rank] = 6;

			mysql_format(connection, equery, sizeof(equery), "UPDATE `user_accounts` SET `character_owns_faction` = '%i', `character_faction` = '%i', `character_faction_rank` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Owns_Faction], PlayerData[playerid][Character_Faction], PlayerData[playerid][Character_Faction_Rank], GetName(playerid));
			mysql_tquery(connection, equery);
				
			printf("[Faction Buy] %s has just purhcased faction id: %d", GetName(playerid), ficonid);
			PlayerAtFactionID[playerid] = 0;
		}
	}
	return 1;
}
/* -------------- START OF HELPER COMMANDS ---------------------- */
CMD:helperchat(playerid, params[]) return cmd_h(playerid, params);
CMD:h(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new amessage[156];
		if(sscanf(params, "s[156]", amessage))
		{
		    SendPlayerServerMessage(playerid, " /h(elperchat) [message]");
		}
		else
		{			
			new dstring[156];
			format(dstring, sizeof(dstring), "[Helper Chat] %s: %s", GetName(playerid), amessage);
			SendHelperMessage(COLOR_CORAL, dstring);
			
			printf("Staff Command: Helperchat | Staff Name: %s | Message: %s", GetName(playerid), amessage);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:helpmetoggle(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1) 
	{
		if(HasPlayerToggledHelpMe[playerid] == 0)
		{
			HasPlayerToggledHelpMe[playerid] = 1;
			
			new dstring[256];
			format(dstring, sizeof(dstring), "> You have just toggled off the notifications for help me requests!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("Staff Command: Helpmetoggle | Staff Name: %s | Off", GetName(playerid));
		}
		else if(HasPlayerToggledHelpMe[playerid] == 1)
		{
		    HasPlayerToggledHelpMe[playerid] = 0;
		    
			new dstring[256];
			format(dstring, sizeof(dstring), "> You have just toggled on the notifications for help me requests!");
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("Staff Command: Helpmetoggle | Staff Name: %s | On", GetName(playerid));
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:nudge(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /nudge [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
	        new Float:x, Float:y, Float:z, Float:dx, Float:dy, Float:angleRad;
	        GetPlayerPos(targetid, x, y, z);

	        new Float:angle;
	        GetPlayerFacingAngle(targetid, angle);

	        angleRad = angle * PI / 180.0;

	        dx = 3 * floatsin(angleRad); 
	        dy = 3 * floatcos(angleRad);

	        SetPlayerPos(targetid, x + dx, y + dy, z);

			new dstring[256];
			format(dstring, sizeof(dstring), "> A staff member has just nudged you!");
            SendClientMessage(targetid, COLOR_YELLOW, dstring);

            format(dstring, sizeof(dstring), "> You have just nuged %s!", GetName(targetid));
            SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("Staff Command: Nudge | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:slap(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /slap [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
	        new Float:x, Float:y, Float:z;
	        GetPlayerPos(targetid, x, y, z);

	        new Float:angle;
	        GetPlayerFacingAngle(targetid, angle);

	        SetPlayerPos(targetid, x, y, z + 5);

			new dstring[256];
			format(dstring, sizeof(dstring), "> A staff member has just slapped you!");
            SendClientMessage(targetid, COLOR_YELLOW, dstring);

            format(dstring, sizeof(dstring), "> You have just slapped %s!", GetName(targetid));
            SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("Staff Command: Slap | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /freeze [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			TogglePlayerControllable(targetid, false);
			
			new dstring[256];
		    format(dstring, sizeof(dstring), "> You have been frozen by staff member [%s], please wait for communication", GetName(playerid));
		    SendClientMessage(targetid, COLOR_YELLOW, dstring);

			new sstring[256];
		    format(sstring, sizeof(sstring), "> You have just frozen player [%s], please make contact with them via /pm", GetName(targetid));
		    SendClientMessage(playerid, COLOR_YELLOW, sstring);
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /unfreeze [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			TogglePlayerControllable(targetid, true);
			
			new dstring[256];
		    format(dstring, sizeof(dstring), "> You have been unfrozen by staff member [%s]", GetName(playerid));
		    SendClientMessage(targetid, COLOR_YELLOW, dstring);

			new sstring[256];
		    format(sstring, sizeof(sstring), "> You have just unfrozen player [%s]", GetName(targetid));
		    SendClientMessage(playerid, COLOR_YELLOW, sstring);
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:spectate(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /spectate [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			if(IsPlayerSpectating[playerid] == 0)
			{
				IsPlayerSpectating[playerid] = 1;				
				TogglePlayerSpectating(playerid, true);
				
				GetPlayerPos(playerid, SpectateX[playerid], SpectateY[playerid], SpectateZ[playerid]);
				
				if(IsPlayerInAnyVehicle(targetid))
				{
					SetPlayerInterior(playerid, GetPlayerInterior(targetid));
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
					PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
					
					new dstring[256];
		            format(dstring, sizeof(dstring), "> You are now spectating %s's vehicle!", GetName(targetid));
		            SendClientMessage(playerid, COLOR_YELLOW, dstring);
				}
				else
				{
					SetPlayerInterior(playerid, GetPlayerInterior(targetid));
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
					PlayerSpectatePlayer(playerid, targetid);
					
					new dstring[256];
		            format(dstring, sizeof(dstring), "> You are now spectating %s!", GetName(targetid));
		            SendClientMessage(playerid, COLOR_YELLOW, dstring);
				}
				
				printf("Staff Command: Spectate | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
			else return SendPlayerErrorMessage(playerid, " You need to end your current spectate first before starting a new one!");
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:endspectate(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    if(IsPlayerSpectating[playerid] == 1)
		{
			IsPlayerSpectating[playerid] = 0;
				
		    TogglePlayerSpectating(playerid, false);
		
			SetPlayerPos(playerid, SpectateX[playerid], SpectateY[playerid], SpectateZ[playerid]);
		   	SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		
			SpectateX[playerid] = 0;
			SpectateY[playerid] = 0;
			SpectateZ[playerid] = 0;
	
			new dstring[256];
	        format(dstring, sizeof(dstring), "> You have now finished spectating");
	        SendClientMessage(playerid, COLOR_YELLOW, dstring);
	
			printf("Staff Command: Endspectate | Staff Name: %s", GetName(playerid));
		}
		else return SendPlayerErrorMessage(playerid, " You are not spectating anyone at this time!");
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:playertype(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1 || PlayerData[playerid][Helper_Level] >= 1)
	{
	    new targetid, type[50];
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /playertype [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			if(IsPlayerUsingClient[playerid] == true) { type = "Yes"; } else { type = "No"; }
			
			new dstring[256];
		    format(dstring, sizeof(dstring), "> Is %s using an official client? %s", GetName(targetid), type);
		    SendClientMessage(playerid, COLOR_YELLOW, dstring);
		
			printf("Staff Command: Spectate | Staff Name: %s | Player Name: %s | Player Type: %s", GetName(playerid), GetName(targetid), type);
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

/* -------------- START OF MODERATOR COMMANDS ---------------------- */

CMD:moderatorchat(playerid, params[]) return cmd_m(playerid, params);
CMD:m(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new amessage[156];
		if(sscanf(params, "s[156]", amessage))
		{
		    SendPlayerServerMessage(playerid, " /m(oderatorchat) [message]");
		}
		else
		{							
			new dstring[156];
			format(dstring, sizeof(dstring), "[Moderator Chat] %s: %s", GetName(playerid), amessage);
			SendModeratorMessage(COLOR_LIGHTSEAGREEN, dstring);
			
			printf("Staff Command: Moderatorchat | Staff Name: %s | Message: %s", GetName(playerid), amessage);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:jetpack(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] > 0 || PlayerData[playerid][Moderator_Level] > 0)
	{
	    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	    SendPlayerServerMessage(playerid, "You have just spawned yourself a jetpack using a staff command");
	
		printf("Staff Command: Jetpack | Staff Name: %s", GetName(playerid));
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:kick(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new targetid, reason[50];

	    if(sscanf(params, "is[50]", targetid, reason))
		{
		    SendPlayerServerMessage(playerid, " /kick [targetid] [reason]");
		}
		else
		{
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot kick yourself from the server, try again!"); 
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:%s has just been kicked by %s [Reason: %s]", GetName(targetid), GetName(playerid), reason);
			SendClientMessageToAll(COLOR_RED, dstring);

			SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this admin action by taking a screenshot and report this on the forums!");
			
			printf("Staff Command: Kick | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			
			Kick(targetid);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:reports(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
		{
		    new query[128];
		    mysql_format(connection, query, sizeof(query), "SELECT * FROM `report_information` WHERE `report_status` = '0'");
			mysql_tquery(connection, query, "OnReportCheck", "i", playerid);
			
			printf("Staff Command: Reports | Staff Name: %s ", GetName(playerid));
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:closereport(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
		{
		    new reportid;
		    
		    if(sscanf(params, "i", reportid))
			{
			    SendPlayerServerMessage(playerid, " /closereport [reportid]");
			}
			else
			{
			    new query[128];
			    mysql_format(connection, query, sizeof(query), "SELECT * FROM `report_information` WHERE `report_id` = '%d' AND `report_status` = '0' ", reportid);
				mysql_tquery(connection, query, "OnReportCloseCheck", "i", playerid);
				
				printf("Staff Command: Closereport | Staff Name: %s", GetName(playerid));
			}
		}
		else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

CMD:gotobiz(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new businessid;
	    if(sscanf(params, "i", businessid))
	    {
	        SendPlayerServerMessage(playerid, " /gotobiz [business id]");
	    }
	    else
	    {
	        if(BusinessData[businessid][Business_Outside_X] == 0) return SendPlayerErrorMessage(playerid, " You cannot teleport to a business that doesn't exist!");
	        {
	        	SetPlayerPos(playerid, BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z]);

		        new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have succesfully teleported to business id: %i", businessid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
				
				printf("Staff Command: Gotobiz | Staff Name: %s", GetName(playerid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotodoor(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new doorid;
	    if(sscanf(params, "i", doorid))
	    {
	        SendPlayerServerMessage(playerid, " /gotodoor [doorid]");
	    }
	    else
	    {
	        if(DoorData[doorid][Door_Outside_X] == 0) return SendPlayerErrorMessage(playerid, " You cannot teleport to a door that doesn't exist!");
	        {
	        	SetPlayerPos(playerid, DoorData[doorid][Door_Outside_X], DoorData[doorid][Door_Outside_Y], DoorData[doorid][Door_Outside_Z]);

		        new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have succesfully teleported to door id: %i", doorid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
				
				printf("Staff Command: Gotodoor | Staff Name: %s", GetName(playerid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotocar(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new carid;
	    if(sscanf(params, "i", carid))
	    {
	        SendPlayerServerMessage(playerid, " /gotocar [vehicle id]");
	    }
	    else
	    {
	        new Float:cwx2,Float:cwy2,Float:cwz2;
			GetVehiclePos(carid, cwx2, cwy2, cwz2);
			
			if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, cwx2, cwy2, cwz2+2);
			}
			else
			{
				SetPlayerPos(playerid, cwx2, cwy2, cwz2+2);
				
				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have succesfully teleported to vehicle id: %i", carid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
				
				printf("Staff Command: Gotocar | Staff Name: %s", GetName(playerid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1 || PlayerData[playerid][Moderator_Level] >= 1)
	{
	    new houseid;
	    if(sscanf(params, "i", houseid))
	    {
	        SendPlayerServerMessage(playerid, " /gotohouse [houseid]");
	    }
	    else
	    {
	        if(HouseData[houseid][House_Outside_X] == 0) return SendPlayerErrorMessage(playerid, " You cannot teleport to a house that doesn't exist!");
	        {
	        	SetPlayerPos(playerid, HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z]);

		        new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have succesfully teleported to house id: %i", houseid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
				
				printf("Staff Command: Gotohouse | Staff Name: %s", GetName(playerid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:getplayer(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Moderator_Level] > 0 || PlayerData[playerid][Admin_Level] > 0)
	{
	    new targetid;
	    new Float:x, Float:y, Float:z;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /getplayer [playerid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot teleport to yourself!"); 
			else
			{
		        GetPlayerPos(playerid, x, y, z);
		        SetPlayerPos(targetid, x, y, z);
				SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
				SetPlayerInterior(targetid, GetPlayerInterior(playerid));
	
		        new dstring[250];
	            format(dstring, sizeof(dstring), "[ADMIN ALERT]:{FFFFFF} %s has just teleported %s to their location!", GetName(playerid), GetName(targetid));
				SendAdminMessage(COLOR_RED, dstring);
				
				printf("Staff Command: Getplayer | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotoplayer(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Moderator_Level] > 0 || PlayerData[playerid][Admin_Level] > 0)
	{
	    new targetid;
	    new Float:x, Float:y, Float:z;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /gotoplayer [playerid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot teleport to yourself!"); 
			else
			{
		        GetPlayerPos(targetid, x, y, z);
		        SetPlayerPos(playerid, x, y, z);
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
				SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	
		        new dstring[250];
	            format(dstring, sizeof(dstring), "[ADMIN ALERT]:{FFFFFF} %s has just teleported to %s's current location!", GetName(playerid), GetName(targetid));
				SendAdminMessage(COLOR_RED, dstring);
				
				printf("Staff Command: Gotoplayer | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

/* -------------- START OF ADMIN LEVEL 1 COMMANDS ---------------------- */
CMD:adminchat(playerid, params[]) return cmd_a(playerid, params);
CMD:a(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new amessage[156];
		if(sscanf(params, "s[156]", amessage))
		{
		    SendPlayerServerMessage(playerid, " /a(dminchat) [message]");
		}
		else
		{
			new dstring[156];
			format(dstring, sizeof(dstring), "[Admin Chat] %s: %s", GetName(playerid), amessage);
			SendAdminMessage(COLOR_RED, dstring);
			
			printf("Staff Command: Adminchat | Staff Name: %s | Message: %s", GetName(playerid), amessage);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:ban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new targetid, reason[50];

	    if(sscanf(params, "is[50]", targetid, reason))
		{
		    SendPlayerServerMessage(playerid, " /ban [targetid] [reason]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!"); 
			if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot ban yourself from the server, try again!"); 
			if(PlayerData[targetid][Character_Ban] == 1) return SendPlayerErrorMessage(playerid, " You cannot someone again who has already been hammered!"); 
			
			PlayerData[targetid][Character_Ban] = 1;
			
			new updatequery[2000];
			mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_ban` = 1 WHERE `character_name` = '%e' LIMIT 1", GetName(targetid));
			mysql_tquery(connection, updatequery);
			
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]: %s has just been banned by %s [Reason: %s]", GetName(targetid), GetName(playerid), reason);
			SendClientMessageToAll(COLOR_RED, dstring);

			SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this admin action by taking a screenshot and report this on the discord!");
			
			printf("Staff Command: Ban | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			
			Kick(targetid);			
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:offlineban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new targetname[50], reason[50];

	    if(sscanf(params, "s[50]s[50]", targetname, reason))
		{
		    SendPlayerServerMessage(playerid, " /offlineban [character_name] [reason]");
		}
		else
		{
			if(strcmp(targetname, PlayerData[playerid][Character_Name], false) == 0) return SendPlayerErrorMessage(playerid, " You cannot offline ban yourself!");	
			
			BanName[playerid] = targetname;	
					
			new query[128];
			mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_name` = '%e' AND `character_ban` = 0 LIMIT 1", targetname);
			mysql_tquery(connection, query, "OnBanCheck", "i", playerid);	
			
			printf("Staff Command: Offlineban | Staff Name: %s | Player Name: %s", GetName(playerid), targetname);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:unban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new targetname[50];

	    if(sscanf(params, "s[50]", targetname))
		{
		    SendPlayerServerMessage(playerid, " /unban [character_name]");
		}
		else
		{
			if(strcmp(targetname, PlayerData[playerid][Character_Name], false) == 0) return SendPlayerErrorMessage(playerid, " You cannot unban yourself!");			
						
			BanName[playerid] = targetname;
					
			new query[128];
			mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_name` = '%e' AND `character_ban` = 1 LIMIT 1", targetname);
			mysql_tquery(connection, query, "OnUnbanCheck", "i", playerid);
			
			printf("Staff Command: Gotoplayer | Staff Name: %s | Player Name: %s", GetName(playerid), targetname);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotols(playerid,params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 1)
    {
	   	SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
	   	SetPlayerInterior(playerid, 0);
	    SetPlayerVirtualWorld(playerid, 0);
		    
	   	new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just teleported to Los Santos Central Map");
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("Staff Command: Gotols | Staff Name: %s ", GetName(playerid));
		
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotopos(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] >= 1)
	{

		new Float:x, Float:y, Float:z, intid, vw;
		if(sscanf(params, "fffii", x, y, z, intid, vw))
		{
		    SendPlayerServerMessage(playerid, " /gotopos [X] [Y] [Z] [Interior ID] [Virtual World]");
		}
		else
		{
		    SetPlayerPos(playerid, x, y, z);
		    SetPlayerInterior(playerid, intid);
		    SetPlayerVirtualWorld(playerid, vw);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have succesfully teleported to location: %f, %f, %f, Interior ID: %i and VW: %i", x, y, z, intid, vw);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Gotopos | Staff Name: %s ", GetName(playerid));
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:rajail(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new targetid;

	    if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /rajail [targetid]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
		    if(PlayerData[targetid][Admin_Jail] == 0) return SendPlayerErrorMessage(playerid, " You cannot un admin jail someone who isn't serving a time!");
			
			new emptystring[50] = "";

			PlayerData[targetid][Admin_Jail] = 0;
			PlayerData[targetid][Admin_Jail_Time] = 0;
			PlayerData[targetid][Admin_Jail_Reason] = emptystring;
			
		    SetPlayerPos(targetid, 811.2561, -1098.2684, 25.9063);
			SetPlayerFacingAngle(targetid, 240.8300);

			SetPlayerInterior(targetid, 0);
			SetPlayerVirtualWorld(targetid, 0);

			SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}You have been released from your admin jail sentence early! Make sure you read up on the rules!");
			
			printf("Staff Command: RemoveAdminJail | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:ajail(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 1)
	{
	    new targetid;
		new minutes;
	    new reason[50];
	    
	    if(sscanf(params, "iis[50]", targetid, minutes, reason))
		{
		    SendPlayerServerMessage(playerid, " /ajail [targetid] [minutes] [reason]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
		    if(targetid == playerid)
		    {
		        PlayerData[playerid][Admin_Jail] = 1;
				PlayerData[playerid][Admin_Jail_Time] = minutes;
				PlayerData[playerid][Admin_Jail_Reason] = reason;

			    SetPlayerPos(playerid, 340.2295, 163.5576, 1019.9912);
				SetPlayerFacingAngle(playerid, 0.8699);

				SetPlayerInterior(playerid, 3);
				SetPlayerVirtualWorld(playerid, playerid++);
				
				new namestring[MAX_PLAYER_NAME];
			    format(namestring, sizeof(namestring), "%s", GetName(playerid));

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]: A staff member has jailed themself. Reason: %s", reason);
				SendClientMessageToAll(COLOR_RED, dstring);

				SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this admin action by taking a screenshot and report this on the forums!");
				SendClientMessage(playerid, COLOR_RED, "[SERVER]: {FFFFFF}[/time to check remain sentence]");
		    }
		    else if(targetid != playerid)
		    {
			    PlayerData[targetid][Admin_Jail] = 1;
				PlayerData[targetid][Admin_Jail_Time] = minutes;
				PlayerData[targetid][Admin_Jail_Reason] = reason;

			    SetPlayerPos(targetid, 340.2295, 163.5576, 1019.9912);
				SetPlayerFacingAngle(targetid, 0.8699);

				SetPlayerInterior(targetid, 3);
				SetPlayerVirtualWorld(targetid, targetid++);

				new namestring[MAX_PLAYER_NAME];
			    format(namestring, sizeof(namestring), "%s", GetName(targetid));

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]: %s has just been admin jailed for reason: %s", GetName(targetid), reason);
				SendClientMessageToAll(COLOR_RED, dstring);

				SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}You can dispute this admin action by taking a screenshot and report this on the forums!");
				SendClientMessage(targetid, COLOR_RED, "[SERVER]: {FFFFFF}[/time to check remain sentence]");
			}
			printf("Staff Command: Adminjail | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

/* -------------- START OF ADMIN LEVEL 2 COMMANDS ---------------------- */
CMD:getcar(playerid,params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new vehicleid;
		if(sscanf(params, "i", vehicleid))
		{
		    SendPlayerServerMessage(playerid, " /getcar [vehicleid]");
		}
		else
		{
		    if(vehicleid == INVALID_VEHICLE_ID) return SendPlayerErrorMessage(playerid, " You cannot get this vehicle ID to your location!");
		    else
		    {
				new Float:x, Float:y, Float:z, dstring[250];
				GetPlayerPos(playerid, x, y, z);

				SetVehiclePos(vehicleid, x, y, z+3);

				format(dstring, sizeof(dstring), "> You have just relocated vehicle id: %d to your current location!", vehicleid);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Getcar | Staff Name: %s", GetName(playerid));
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:unmute(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new targetid;
		if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /unmute [targetid]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else if(IsPlayerMuted[targetid] == 0) return SendPlayerErrorMessage(playerid, " You cannot unmute someone who isn't muted!");
		    else
		    {
			    IsPlayerMuted[targetid] = 0;

				new dstring[156];
				format(dstring, sizeof(dstring), "[SERVER]:%s has been unmuted by a server admin", GetName(targetid));
				SendClientMessageToAll(COLOR_RED, dstring);

				printf("Staff Command: Unmute | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:mute(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new amessage[156], targetid;
		if(sscanf(params, "is[156]", targetid, amessage))
		{
		    SendPlayerServerMessage(playerid, " /mute [targetid] [reason]");
		}
		else
		{
		    if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else if(targetid == playerid) return SendPlayerErrorMessage(playerid, " You cannot mute yourself!");
			else if(IsPlayerMuted[targetid] == 1) return SendPlayerErrorMessage(playerid, " You cannot mute someone who is already muted!");
		    else
		    {
			    IsPlayerMuted[targetid] = 1;

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:%s has been temp muted by a server admin. Reason: %s", GetName(targetid), amessage);
				SendClientMessageToAll(COLOR_RED, dstring);

				format(dstring, sizeof(dstring), "> If you feel that this temp mute is not justified, please report this action on our forum!");
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				printf("Staff Command: Mute | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:sethealth(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new targetid, healthamount;
		if(sscanf(params, "ii", targetid, healthamount))
		{
		    SendPlayerServerMessage(playerid, " /sethealth [targetid] [health amount]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			if(healthamount >= 0 && healthamount < 101)
			{
			    SetPlayerHealth(targetid, healthamount);
	
			    new dstring[256];
				format(dstring, sizeof(dstring), "> Admin has set your health amount to: %i!", healthamount);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
	
				format(dstring, sizeof(dstring), "> You have just set %s's health amount to: %i!", GetName(targetid), healthamount);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Sethealth | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
				
				if(healthamount == 0)
				{
				    IsPlayerInjured[targetid] = 1;
				}
			}
			else return SendPlayerErrorMessage(playerid, " You cannot set someones health to a ungodly number [Between 0 and 100]!");
		}
	}
	return 1;
}

/* -------------- START OF ADMIN LEVEL 3 COMMANDS ---------------------- */
CMD:avrespawn(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 3)
	{
	    new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just respawned all the vehicles in the server!");
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		format(dstring, sizeof(dstring), "[SERVER]: %s has just respawned all the vehicles in the server!", GetName(playerid));
		SendClientMessageToAll(COLOR_RED, dstring);

        for (new i = 1; i < MAX_VEHICLES; i++)
		{
		    SetVehicleToRespawn(i);
		}
		
		printf("Staff Command: Vehiclerespawn | Staff Name: %s ", GetName(playerid));
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:avrefill(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 3)
	{
	    new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just refilled all the vehicles in the server!");
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		format(dstring, sizeof(dstring), "[SERVER]: %s has just refilled all the vehicles in the server!", GetName(playerid));
		SendClientMessageToAll(COLOR_RED, dstring);

		for (new i = 1; i < MAX_VEHICLES; i++)
		{
		    VehicleData[i][Vehicle_Fuel] = 100;
		}
		
		printf("Staff Command: Vehiclerefill | Staff Name: %s ", GetName(playerid));
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 3)
	{
	    new targetid, skinid;
		if(sscanf(params, "ii", targetid, skinid))
		{
		    SendPlayerServerMessage(playerid, " /setskin [targetid] [skinid (1 - 311)]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(skinid < 3 || skinid > 311) return SendPlayerServerMessage(playerid, " You cannot set a skin that doesn't exist");
			else
			{
			    SetPlayerSkin(targetid, skinid);
			    
			    new dstring[256];
				format(dstring, sizeof(dstring), "> Admin has set your skin id to: %i!", skinid);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
	
				format(dstring, sizeof(dstring), "> You have just set %s's skin id to: %i!", GetName(targetid), skinid);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Setskin | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
		}
	}
	return 1;
}

CMD:setarmour(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 3)
	{
	    new targetid, armouramount;
		if(sscanf(params, "ii", targetid, armouramount))
		{
		    SendPlayerServerMessage(playerid, " /setarmour [targetid] [armour amount]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
			if(armouramount >= 0 && armouramount < 101)
			{
			    SetPlayerArmour(targetid, armouramount);
	
			    new dstring[256];
				format(dstring, sizeof(dstring), "> Admin has set your armour amount to: %i!", armouramount);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
	
				format(dstring, sizeof(dstring), "> You have just set %s's armour amount to: %i!", GetName(targetid), armouramount);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Setarmour | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
			else return SendPlayerErrorMessage(playerid, " You cannot set someones armour to a ungodly number [Between 0 and 100]!");
		}
	}
	return 1;
}

/* -------------- START OF ADMIN LEVEL 4 COMMANDS ---------------------- */
CMD:weaponban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /weaponban [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
	        if(IsPlayerWeaponBanned[targetid] == 1) return SendPlayerErrorMessage(playerid, " You cannot weapon ban a player who already is banned - use /rweaponban to remove it!");
		 	else
		 	{
		 	    IsPlayerWeaponBanned[targetid] = 1;
		 	    ResetPlayerWeapons(targetid);
		 	    
		 	    new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:%s has been temp weapon banned by %s from using their weapons!", GetName(targetid), GetName(playerid));
				SendClientMessageToAll(COLOR_RED, dstring);
				
				printf("Staff Command: Weaponban | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
		 	}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:rweaponban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid;
	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /rweaponban [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
	        if(IsPlayerWeaponBanned[targetid] == 0) return SendPlayerErrorMessage(playerid, " You cannot remove a weapon ban against a player who isn't weapon banned!");
		 	else
		 	{
		 	    IsPlayerWeaponBanned[targetid] = 0;

		 	    new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:%s has had their temp weapon ban lifted by %s!", GetName(targetid), GetName(playerid));
				SendClientMessageToAll(COLOR_RED, dstring);
				
				printf("Staff Command: Removeweaponban | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
		 	}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:factionban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid;

 	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /factionban [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(PlayerData[targetid][Character_Faction_Ban] == 1) return SendPlayerErrorMessage(playerid, " You cannot faction ban someone who already is. Use /rfactionban to remove it!");
			else
			{
			    PlayerData[targetid][Character_Faction_Ban] = 1;
			    
			    new query[2000];
		        mysql_format(connection, query, sizeof(query), "UPDATE `user_accounts` SET `character_faction_ban` = '1' WHERE `character_name` = '%e' LIMIT 1", GetName(targetid));
	    		mysql_tquery(connection, query);
	    		
	    		new dstring[256];
				format(dstring, sizeof(dstring), "> Admin has just faction banned you! If you feel this is incorrect, please report on forums");
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have just faction banned %s, please make sure this is correct!", GetName(targetid));
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Factionban | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:rfactionban(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid;

 	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /rfactionban [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			if(PlayerData[targetid][Character_Faction_Ban] == 0) return SendPlayerErrorMessage(playerid, " You cannot remove a faction ban from someone who doesn't have one!");
			else
			{
			    PlayerData[targetid][Character_Faction_Ban] = 0;

			    new query[2000];
		        mysql_format(connection, query, sizeof(query), "UPDATE `user_accounts` SET `character_faction_ban` = '0' WHERE `character_name` = '%e' LIMIT 1", GetName(targetid));
	    		mysql_tquery(connection, query);

	    		new dstring[256];
				format(dstring, sizeof(dstring), "> An admin has just removed a faction ban from your account!");
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have just removed a faction ban from %s, please make sure this is correct!", GetName(targetid));
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				printf("Staff Command: Removefactionban | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:setlicense(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid, license, status;

	    if(sscanf(params, "iii", targetid, license, status))
	    {
	        SendPlayerServerMessage(playerid, " /setlicense [targetid] [license type] [status]");
		    SendPlayerServerMessage(playerid, " Licenses: [1 - Motorcycle | 2 - Car | 3 - Truck | 4 - Boat | 5 - Flying | 6 - Firearms]");
		    SendPlayerServerMessage(playerid, " Status: [1 - Issue | 2 - Revoke]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				printf("Staff Command: Setlicense | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
				
				if(license == 1)
				{
				    PlayerData[targetid][Character_License_Motorcycle] = status;
				    
				    new updatequery[2000];
    				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_motorcycle` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Motorcycle], GetName(targetid));
			    	mysql_tquery(connection, updatequery);
				    	
				    if(status == 1)
				    {
                	    new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Motorcycle License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Motorcycle License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
					}
					else
					{
	                    new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Motorcycle License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Motorcycle License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
				    }
				}
				else if(license == 2)
				{
				    PlayerData[targetid][Character_License_Car] = status;
				    
				    new updatequery[2000];
    				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_car` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Car], GetName(targetid));
			    	mysql_tquery(connection, updatequery);
				    	
				    if(status == 1)
				    {
                	    new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Car License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Car License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
         			}
					else
					{
                    	new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Car License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Car License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
		    		}
				}
				else if(license == 3)
				{
					PlayerData[targetid][Character_License_Truck] = status;
					
					new updatequery[2000];
    				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_truck` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Truck], GetName(targetid));
    				mysql_tquery(connection, updatequery);
				    	
	    			if(status == 1)
	    			{
     					new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Truck License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Truck License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
	    			}
	    			else
	    			{
     					new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Truck License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Truck License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
	    			}
				}
				else if(license == 4)
				{
    				PlayerData[targetid][Character_License_Boat] = status;
    				
    				new updatequery[2000];
   					mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_boat` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Boat], GetName(targetid));
			    	mysql_tquery(connection, updatequery);
    				
    				if(status == 1)
    				{
    					new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Boat License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Boat License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
    				}
    				else
    				{
    					new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Boat License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Boat License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
    				}
				}
				else if(license == 5)
				{
    				PlayerData[targetid][Character_License_Flying] = status;
    				
    				new updatequery[2000];
    				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_flying` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Flying], GetName(targetid));
			    	mysql_tquery(connection, updatequery);
				    	
   					if(status == 1)
   					{
   						new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Flying License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Flying License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
   					}
   					else
   					{
   						new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Flying License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Flying License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
   					}
				}
				else if(license == 6)
				{
   					PlayerData[targetid][Character_License_Firearms] = status;
   					
   					new updatequery[2000];
    				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_license_firearms` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_License_Firearms], GetName(targetid));
			    	mysql_tquery(connection, updatequery);
				    	
   					if(status == 1)
   					{
   						new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has given you a Firearms License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have issued a Firearms License to %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
   					}
   					else
   					{
						new dstring[256];
						format(dstring, sizeof(dstring), "> An Admin has revoked your Firearms License");
						SendClientMessage(targetid, COLOR_YELLOW, dstring);
						
						format(dstring, sizeof(dstring), "> You have revoked a Firearms License from %s", GetName(targetid));
						SendClientMessage(playerid, COLOR_YELLOW, dstring);
					}
				}
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 4)
	{
	    new targetid, money;

	    if(sscanf(params, "ii", targetid, money))
	    {
	        SendPlayerServerMessage(playerid, " /givemoney [targetid] [amount]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
	        PlayerData[targetid][Character_Money] += money;

	        new dstring[256];
			format(dstring, sizeof(dstring), "> Admin has given you $%i!", money);
			SendClientMessage(targetid, COLOR_YELLOW, dstring);

			format(dstring, sizeof(dstring), "> You have just given %s $%i!", GetName(targetid), money);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("Staff Command: Givemoney | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:givephone(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 4)
    {
        new targetid;

        if(sscanf(params, "i", targetid))
        {
            SendPlayerServerMessage(playerid, " /givephone [targetid]");
        }
        else
        {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
            new dstring[256];

            SQL_PHONENUMBER_USED = 0;

            new MAX_ATTEMPTS = 3;
            for (new i = 0; i < MAX_ATTEMPTS; i++)
            {
                if(SQL_PHONENUMBER_USED == 0)
                {
                    SQL_PHONENUMBER_GENERATED = 100000 + random(900000);

                    new query[128];
				    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_phonenumber` = '%i' LIMIT 1", SQL_PHONENUMBER_GENERATED);
					mysql_tquery(connection, query, "GetNextPhoneNumber");
                }
                else return 1;
            }
            printf("%d", SQL_PHONENUMBER_GENERATED);
            
            PlayerData[targetid][Character_Has_Phone] = 1;
            PlayerData[targetid][Character_Has_SimCard] = 1;
            PlayerData[targetid][Character_Phonenumber] = SQL_PHONENUMBER_GENERATED;

            format(dstring, sizeof(dstring), "> Admin has given you a phone with number (%d)!", SQL_PHONENUMBER_GENERATED);
            SendClientMessage(targetid, COLOR_YELLOW, dstring);

            format(dstring, sizeof(dstring), "> You have just given %s a phone with number (%d)!", GetName(targetid), SQL_PHONENUMBER_GENERATED);
            SendClientMessage(playerid, COLOR_YELLOW, dstring);

			printf("Staff Command: Givephone | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
        }
    }
    else
    {
        return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    }
    return 1;
}

/* -------------- START OF ADMIN LEVEL 5 COMMANDS ---------------------- */
CMD:giveweapon(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 5)
	{
	    new targetid;

	    if(sscanf(params, "i", targetid))
	    {
	        SendPlayerServerMessage(playerid, " /giveweapon [targetid]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
	        GivePlayerWeapon(targetid, WEAPON_SAWEDOFF, 64);
	
			printf("Staff Command: Giveweapon | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:starttornado(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 5)
	{
		TornadoObject1 = CreateObject(18715, 152.57185, -1965.65540, 4.49668,   0.00000, 0.00000, 0.00000);
		TornadoObject2 = CreateObject(18715, 151.03667, -1965.95276, 19.83816,   0.00000, 0.00000, 0.00000);
		TornadoObject3 = CreateObject(18715, 149.76260, -1966.30908, 37.37214,   0.00000, 0.00000, 0.00000);
		TornadoObject4 = CreateObject(18715, 148.55931, -1967.96655, 58.22157,   0.00000, 0.00000, 0.00000);
		TornadoObject5 = CreateObject(18715, 146.91696, -1967.63281, 85.09078,   0.00000, 0.00000, 0.00000);
		TornadoObject6 = CreateObject(18715, 148.83975, -1967.02454, 124.72430,   0.00000, 0.00000, 0.00000);
		
		MoveObject(TornadoObject1, 2927.6304, -1279.1519, 4.49668, 1.0, 0.00000, 0.00000, 0.00000);
		MoveObject(TornadoObject2, 2927.6304, -1279.1519, 19.83816, 1.0, 0.00000, 0.00000, 0.00000);
		MoveObject(TornadoObject3, 2927.6304, -1279.1519, 37.37214, 1.0, 0.00000, 0.00000, 0.00000);
		MoveObject(TornadoObject4, 2927.6304, -1279.1519, 58.22157, 1.0, 0.00000, 0.00000, 0.00000);
		MoveObject(TornadoObject5, 2927.6304, -1279.1519, 85.09078, 1.0, 0.00000, 0.00000, 0.00000);
		MoveObject(TornadoObject6, 2927.6304, -1279.1519, 124.72430, 1.0, 0.00000, 0.00000, 0.00000);
		
		SendClientMessageToAll(COLOR_PINK, "[CNN NEWS]:{FFFFFF} WEATHER ALERT! TORNADO IN COMING, GET TO SHELTHER!");
		
		printf("Staff Command: Starttornado | Staff Name: %s", GetName(playerid));
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;

}

CMD:stoptornado(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] >= 5)
	{
		DestroyObject(TornadoObject1);
     	DestroyObject(TornadoObject2);
     	DestroyObject(TornadoObject3);
     	DestroyObject(TornadoObject4);
		DestroyObject(TornadoObject5);
		DestroyObject(TornadoObject6);
	    
	    TornadoTimer = 0;
			
		SendClientMessageToAll(COLOR_PINK, "[CNN NEWS]:{FFFFFF} TORNADO HAS LEFT OUR CITY, LETS CHECK ON OUR NEIGHBOURS!");
		
		printf("Staff Command: Stoptornado | Staff Name: %s", GetName(playerid));
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;

}

CMD:givecoins(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new targetid, coins;
	    
	    if(sscanf(params, "ii", targetid, coins))
	    {
	        SendPlayerServerMessage(playerid, " /givecoins [targetid] [amount]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			
	        PlayerData[targetid][Character_Coins] += coins;
	        
	        new dstring[256];
			format(dstring, sizeof(dstring), "> Admin has given you %i coins!", coins);
			SendClientMessage(targetid, COLOR_YELLOW, dstring);

			format(dstring, sizeof(dstring), "> You have just given %s %i coins!", GetName(targetid), coins);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
			
			printf("Staff Command: Givecoins | Staff Name: %s | Player Name: %s", GetName(playerid), GetName(targetid));
	    }
	}
	return 1;
}

CMD:vsetfaction(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid, factionid;
	    
	    vehicleid = GetPlayerVehicleID(playerid);
	    
		if(sscanf(params, "i", factionid))
		{
			SendPlayerServerMessage(playerid, " /vsetfaction [factionid]");
		}
		else
		{
		    if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

			VehicleData[vehicleid][Vehicle_Faction] = factionid;
			
            new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_faction` = '%i' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Faction], VehicleData[vehicleid][Vehicle_ID]);
    		mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set vehicle id: %i faction to: %i!", VehicleData[vehicleid][Vehicle_ID], factionid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Vsetfaction | Staff Name: %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:vsetjob(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid, jobid;
	    
	    vehicleid = GetPlayerVehicleID(playerid);
	    
		if(sscanf(params, "i", jobid))
		{
			SendPlayerServerMessage(playerid, " /vsetjob [jobid]");
		}
		else
		{
		    if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

			VehicleData[vehicleid][Vehicle_Job] = jobid;
			
            new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_job` = '%i' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Job], VehicleData[vehicleid][Vehicle_ID]);
    		mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set vehicle id: %i job to: %i!", VehicleData[vehicleid][Vehicle_ID], jobid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Vsetjob | Staff Name: %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:vtype(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid, type;

	    vehicleid = GetPlayerVehicleID(playerid);

		if(sscanf(params, "i", type))
		{
			SendPlayerServerMessage(playerid, " /vtype [0 - Reset | 1 - Public | 2 - Rental]");
		}
		else
		{
		    if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

			VehicleData[vehicleid][Vehicle_Type] = type;

            new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_type` = '%i' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Type], VehicleData[vehicleid][Vehicle_ID]);
    		mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set vehicle id: %i type to: %i!", VehicleData[vehicleid][Vehicle_ID], type);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Vsettype | Staff Name: %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:vremovefaction(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid;

	    vehicleid = GetPlayerVehicleID(playerid);

		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

        VehicleData[vehicleid][Vehicle_Faction] = 0;

        new query[2000];
	    mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_faction` = '0' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_ID]);
    	mysql_tquery(connection, query);

		new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just removed vehicle id: %i from a faction!", VehicleData[vehicleid][Vehicle_ID]);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("Staff Command: Vremovefaction | Staff Name: %s", GetName(playerid));
	}
	return 1;
}

CMD:vsetowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid, targetid, ownername[50];

	    vehicleid = GetPlayerVehicleID(playerid);

		if(sscanf(params, "i", targetid))
		{
			SendPlayerServerMessage(playerid, " /vsetowner [playerid]");
		}
		else
		{
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
		    if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

			ownername = GetName(targetid);
			VehicleData[vehicleid][Vehicle_Owner] = ownername;

            new query[2000];
	        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_owner` = '%s' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Owner], VehicleData[vehicleid][Vehicle_ID]);
    		mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set vehicle id: %i owner to: %s!", VehicleData[vehicleid][Vehicle_ID], ownername);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Vsetowner | Staff Name: %s", GetName(playerid));
		}
	}
	return 1;
}

CMD:vremoveowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid;
	    new emptystring[50] = "";

	    vehicleid = GetPlayerVehicleID(playerid);

		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");


		VehicleData[vehicleid][Vehicle_Owner] = emptystring;

        new query[2000];
        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_owner` = '' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_ID]);
   		mysql_tquery(connection, query);

		new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just removed vehicle id: %i owner!", VehicleData[vehicleid][Vehicle_ID]);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("Staff Command: Vremoveowner | Staff Name: %s", GetName(playerid));
	}
	return 1;
}

CMD:vpark(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid;
	    new Float:vehx, Float:vehy, Float:vehz, Float:veha;

	    vehicleid = GetPlayerVehicleID(playerid);
	    
		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

        GetVehiclePos(vehicleid, vehx, vehy, vehz);
        GetVehicleZAngle(vehicleid, veha);
		VehicleData[vehicleid][Vehicle_Spawn_X] = vehx;
		VehicleData[vehicleid][Vehicle_Spawn_Y] = vehy;
		VehicleData[vehicleid][Vehicle_Spawn_Z] = vehz;
		VehicleData[vehicleid][Vehicle_Spawn_A] = veha;

        new query[2000];
        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_spawn_x` = '%f', `vehicle_spawn_y` = '%f', `vehicle_spawn_z` = '%f', `vehicle_spawn_a` = '%f' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_Spawn_X], VehicleData[vehicleid][Vehicle_Spawn_Y], VehicleData[vehicleid][Vehicle_Spawn_Z], VehicleData[vehicleid][Vehicle_Spawn_A], VehicleData[vehicleid][Vehicle_ID]);
   		mysql_tquery(connection, query);

		new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just admin parked vehicle id: %i!", VehicleData[vehicleid][Vehicle_ID]);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("Staff Command: Vpark | Staff Name: %s", GetName(playerid));
	}
	return 1;
}

CMD:vcreate(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		if(sscanf(params, "iii", vcreatemodel[playerid], vcreatec1[playerid], vcreatec2[playerid]))
		{
			SendPlayerServerMessage(playerid, " /vcreate [model id] [color 1] [color 2]");
		}
		else
		{
			printf("FindNextFreeVehicle - Started");
	
		    new query[128];
		    mysql_format(connection, query, sizeof(query), "SELECT * FROM `vehicle_information` WHERE `vehicle_used` = 0 LIMIT 1");
		    mysql_tquery(connection, query, "CollectNextFreeVehicleID");
		}
	}
	return 1;
}

CMD:vdelete(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new vehicleid;
	    new blankstring[50];

	    vehicleid = GetPlayerVehicleID(playerid);
		blankstring = "";
		
		if(vehicleid == 0) return SendPlayerErrorMessage(playerid, " You are not sitting inside a vehicle!");

        VehicleData[vehicleid][Vehicle_Faction] = 0;
		VehicleData[vehicleid][Vehicle_Owner] = blankstring;
		VehicleData[vehicleid][Vehicle_Used] = 0;
		
		VehicleData[vehicleid][Vehicle_Model] = 0;
		VehicleData[vehicleid][Vehicle_Color_1] = 0;
		VehicleData[vehicleid][Vehicle_Color_2] = 0;
		
		VehicleData[vehicleid][Vehicle_Spawn_X] = 0;
		VehicleData[vehicleid][Vehicle_Spawn_Y] = 0;
		VehicleData[vehicleid][Vehicle_Spawn_Z] = 0;
		VehicleData[vehicleid][Vehicle_Spawn_A] = 0;
		
		VehicleData[vehicleid][Vehicle_Lock] = 0;
		VehicleData[vehicleid][Vehicle_Alarm] = 0;
		VehicleData[vehicleid][Vehicle_GPS] = 0;
		VehicleData[vehicleid][Vehicle_Fuel] = 0;
		VehicleData[vehicleid][Vehicle_Type] = 0;
		VehicleData[vehicleid][Vehicle_License_Plate] = 0;

        new query[2000];
        mysql_format(connection, query, sizeof(query), "UPDATE `vehicle_information` SET `vehicle_faction` = '0', `vehicle_owner` = '', `vehicle_used` = '0', `vehicle_model` = '402', `vehicle_color_1` = '0', `vehicle_color_2` = '0', `vehicle_spawn_x` = '0', `vehicle_spawn_y` = '0', `vehicle_spawn_z` = '0', `vehicle_spawn_a` = '0', `vehicle_lock` = '0', `vehicle_alarm` = '0', `vehicle_gps` = '0', `vehicle_license_plate` = '0', `vehicle_fuel` = '0', `vehicle_type` = '0' WHERE `vehicle_id` = '%i' LIMIT 1", VehicleData[vehicleid][Vehicle_ID]);
   		mysql_tquery(connection, query);
   		
   		DestroyVehicle(vehicleid);
   		
   		if(VehicleData[vehicleid][Vehicle_Used] == 0)
     	{
	    	AddStaticVehicleEx(402, 4572.7007, -1116.7518, 0.3459, 180, 1, 1, -1);

			new licenseplate[10];
			format(licenseplate, sizeof(licenseplate), "%s", VehicleData[vehicleid][Vehicle_License_Plate]);
			SetVehicleNumberPlate(vehicleid, licenseplate);
        }

		new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just reset / deleted vehicle id: %i!", VehicleData[vehicleid][Vehicle_ID]);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
		
		printf("Staff Command: Vdelete | Staff Name: %s", GetName(playerid));
	}
	return 1;
}

CMD:vinfo(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new vehicleid;

		if(sscanf(params, "i", vehicleid))
		{
			SendPlayerServerMessage(playerid, " /vinfo [vehicleid]");
		}
		else
		{
			new dstring[256];

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The below information has been pulled directly from the database!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			format(dstring, sizeof(dstring), "{FFFFFF} Vehicle ID: %i | Faction ID: %i | Job ID: %i | Owner: %s", vehicleid, VehicleData[vehicleid][Vehicle_Faction], VehicleData[vehicleid][Vehicle_Job], VehicleData[vehicleid][Vehicle_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			format(dstring, sizeof(dstring), "{FFFFFF} Used: %i | Lock Type: %i | Alarm Type: %i", VehicleData[vehicleid][Vehicle_Used], VehicleData[vehicleid][Vehicle_Lock], VehicleData[vehicleid][Vehicle_Alarm]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			format(dstring, sizeof(dstring), "{FFFFFF} GPS Type: %i | Model: %i", VehicleData[vehicleid][Vehicle_GPS], VehicleData[vehicleid][Vehicle_Model]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			printf("Staff Command: Vinfo | Staff Name: %s", GetName(playerid));
		}
	}
	return 1;
}

/* -------------- START OF ADMIN LEVEL 6 COMMANDS ---------------------- */

CMD:setleader(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 6)
	{
	    new targetid, factionid;
	    
	    if(sscanf(params, "ii", targetid, factionid))
	    {
	        SendPlayerServerMessage(playerid, " /setleader [targetid] [faction id]");
		    SendPlayerServerMessage(playerid, " Factions: [1 - 10]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				PlayerData[targetid][Character_Faction] = factionid;
				PlayerData[targetid][Character_Faction_Rank] = 6;
				
				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `character_faction` = '%i', `character_faction_rank` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Character_Faction], PlayerData[targetid][Character_Faction_Rank], GetName(targetid));
				mysql_tquery(connection, updatequery);

				new dstring[256];
				format(dstring, sizeof(dstring), "> An Admin has given you leadership of: %s", FactionData[factionid][Faction_Name]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have given %s leadership of faction: %s", GetName(targetid), FactionData[factionid][Faction_Name]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:sethelper(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 6)
	{
	    new targetid, helperlevel;

	    if(sscanf(params, "ii", targetid, helperlevel))
	    {
	        SendPlayerServerMessage(playerid, " /sethelper [targetid] [helper level]");
		    SendPlayerServerMessage(playerid, " Levels: [0 - 1]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				PlayerData[targetid][Helper_Level] = helperlevel;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `helper_level` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Helper_Level], GetName(targetid));
				mysql_tquery(connection, updatequery);

				new dstring[256];
				format(dstring, sizeof(dstring), "> An Admin has just set your Helper Level to: %d", helperlevel);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have given %s Helper Level: %d", GetName(targetid), helperlevel);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:setmoderator(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 6)
	{
	    new targetid, modlevel;

	    if(sscanf(params, "ii", targetid, modlevel))
	    {
	        SendPlayerServerMessage(playerid, " /setmoderator [targetid] [moderator level]");
		    SendPlayerServerMessage(playerid, " Levels: [0 - 1]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				PlayerData[targetid][Moderator_Level] = modlevel;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `moderator_level` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Moderator_Level], GetName(targetid));
				mysql_tquery(connection, updatequery);

				new dstring[256];
				format(dstring, sizeof(dstring), "> An Admin has just set your Moderator Level to: %d", modlevel);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have given %s Moderator Level: %d", GetName(targetid), modlevel);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:setadmin(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] >= 6)
	{
	    new targetid, adminlevel;

	    if(sscanf(params, "ii", targetid, adminlevel))
	    {
	        SendPlayerServerMessage(playerid, " /setadmin [targetid] [admin level]");
		    SendPlayerServerMessage(playerid, " Levels: [1 - 6]");
	    }
	    else
	    {
			if(targetid == INVALID_PLAYER_ID) return SendPlayerErrorMessage(playerid, " You cannot target a non existant player id!");
			else
			{
				PlayerData[targetid][Admin_Level] = adminlevel;

				new updatequery[2000];
				mysql_format(connection, updatequery, sizeof(updatequery), "UPDATE `user_accounts` SET `admin_level` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[targetid][Admin_Level], GetName(targetid));
				mysql_tquery(connection, updatequery);

				new dstring[256];
				format(dstring, sizeof(dstring), "> An Admin has just set your Admin Level to: %d", adminlevel);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				format(dstring, sizeof(dstring), "> You have given %s Admin Level: %d", GetName(targetid), adminlevel);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
			}
	    }
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:fnext(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `faction_information` WHERE `faction_name` = '' LIMIT 1");
		mysql_tquery(connection, query, "GetNextFactionValue");
	}
	return 1;
}

CMD:finfo(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;

		if(sscanf(params, "i", factionid))
		{
			SendPlayerServerMessage(playerid, " /finfo [factionid]");
		}
		else
		{
			new dstring[256];

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The below information has been pulled directly from the database!");
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			format(dstring, sizeof(dstring), "{FFFFFF} Faction ID: %i | Faction Name: %s", factionid, FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			format(dstring, sizeof(dstring), "{FFFFFF} Faction Rank 1: %s | Faction Rank 2: %s | Faction Rank 3: %s", FactionData[factionid][Faction_Rank_1], FactionData[factionid][Faction_Rank_2], FactionData[factionid][Faction_Rank_3]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			format(dstring, sizeof(dstring), "{FFFFFF} Faction Rank 4: %s | Faction Rank 5: %s | Faction Rank 6: %s", FactionData[factionid][Faction_Rank_4], FactionData[factionid][Faction_Rank_5], FactionData[factionid][Faction_Rank_6]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			format(dstring, sizeof(dstring), "{FFFFFF} Faction Joining Requests: %i", FactionData[factionid][Faction_Join_Requests]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ficonpos(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;
		new acquery[2000], dstring[256];

		if(sscanf(params, "i", factionid))
		{
			SendPlayerServerMessage(playerid, " /ficonpos [factionid]");
		}
		else
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x,y,z);
			
			FactionData[factionid][Faction_Icon_X] = x;
	        FactionData[factionid][Faction_Icon_Y] = y;
	        FactionData[factionid][Faction_Icon_Z] = z;
	        
	        DestroyDynamicPickup(FactionData[factionid][Faction_Pickup_ID_Outside]);
		    FactionData[factionid][Faction_Pickup_ID_Outside] = CreateDynamicPickup(1239, 1,FactionData[factionid][Faction_Icon_X], FactionData[factionid][Faction_Icon_Y], FactionData[factionid][Faction_Icon_Z], -1);

			mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_icon_x` = '%f',`faction_icon_y` = '%f', `faction_icon_z` = '%f' WHERE `faction_id` = '%i' LIMIT 1", FactionData[factionid][Faction_Icon_X], FactionData[factionid][Faction_Icon_Y], FactionData[factionid][Faction_Icon_Z], factionid);
    		mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Faction(ID: %i) icon position", factionid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:fsetcost(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid, option1, value;

		if(sscanf(params, "iii", factionid, option1, value))
		{
			SendPlayerServerMessage(playerid, " /fsetcost [factionid] [option] [value]");
			SendPlayerServerMessage(playerid, " Options: [Coins (1) | Money (2)]");
		}
		else
		{
		    switch(option1)
		    {
		        case 1:
		        {
		            FactionData[factionid][Faction_Price_Coins] = value;

					new equery[2000];
		      		mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_price_coins` = '%i' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
					mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} Faction ID: %i has been updated with a new coin cost of: %i", factionid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		        case 2:
		        {
		            FactionData[factionid][Faction_Price_Money] = value;

					new equery[2000];
		      		mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_price_money` = '%i' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
					mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} Faction ID: %i has been updated with a new money cost of: %i", factionid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		    }
		}
	}
	return 1;
}

CMD:fsettype(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new factionid, factiontype;

		if(sscanf(params,"ii", factionid, factiontype))
		{
		    SendPlayerServerMessage(playerid, " /fsettype [factionid] [type]");
		    SendPlayerServerMessage(playerid, " Options: [Unsold (0) | Sold (1) | Government (3)]");
		}
		else
		{
		    if(factiontype < 0 || factiontype > 3) return SendPlayerErrorMessage(playerid, " You need to select a valid faction type ID that can be used in-game!");
		    else
		    {
				FactionData[factionid][Faction_Sold] = factiontype;

		    	new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `faction_information` SET `faction_sold` = '%i' WHERE `faction_id` = '%i' LIMIT 1", FactionData[factionid][Faction_Sold], factionid);
				mysql_tquery(connection, equery);

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Faction ID: %i, has had the faction type changed to status: %i", factionid, FactionData[factionid][Faction_Sold]);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
			}
		}
	}
	return 1;
}

CMD:fsetowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid, targetid;
		new acquery[2000], dstring[256];

		if(sscanf(params, "ii", factionid, targetid))
		{
			SendPlayerServerMessage(playerid, " /fsetowner [factionid] [targetid]");
		}
		else
		{
			FactionData[factionid][Faction_Owner] = PlayerData[targetid][Character_Name];

			mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_owner` = '%s' WHERE `faction_id` = '%i' LIMIT 1", FactionData[factionid][Faction_Owner], factionid);
    		mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have set Faction(ID: %i) owner as %s", factionid, GetName(targetid));
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:fremoveowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;
		new acquery[2000], dstring[256];

		if(sscanf(params, "i", factionid))
		{
			SendPlayerServerMessage(playerid, " /fremoveowner [factionid]");
		}
		else
		{
		    new value[50];
		    value = " ";
		    
			FactionData[factionid][Faction_Owner] = value;

			mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_owner` = '%s' WHERE `faction_id` = '%i' LIMIT 1", FactionData[factionid][Faction_Owner], factionid);
    		mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have removed the Faction(ID: %i) owner", factionid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}


CMD:fname(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;
		new acquery[2000], value[20], dstring[300];

		if(sscanf(params, "is[20]", factionid, value))
		{
			SendPlayerServerMessage(playerid, " /fname [factionid] [value]");
		}
		else
		{
			FactionData[factionid][Faction_Name] = value;

			mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_name` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    		mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Faction(ID: %i) name to be %s", factionid, FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:frankname(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid, option;
		new acquery[2000], value[20], dstring[2000];

		if(sscanf(params, "iis[20]", factionid, option, value))
		{
			SendPlayerServerMessage(playerid, " /frankname [factionid] [rank] [value]");
			SendPlayerServerMessage(playerid, " OPTIONS: 1 to 6 - Rank Name");
		}
		else
		{
			switch(option)
			{
			    case 1:
			    {
			        FactionData[factionid][Faction_Rank_1] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_1` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 1 name to be %s", factionid, FactionData[factionid][Faction_Rank_1]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 2:
			    {
			        FactionData[factionid][Faction_Rank_2] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_2` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 2 name to be %s", factionid, FactionData[factionid][Faction_Rank_1]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 3:
			    {
			        FactionData[factionid][Faction_Rank_3] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_3` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 3 name to be %s", factionid, FactionData[factionid][Faction_Rank_3]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 4:
			    {
			        FactionData[factionid][Faction_Rank_4] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_4` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 4 name to be %s", factionid, FactionData[factionid][Faction_Rank_4]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 5:
			    {
			        FactionData[factionid][Faction_Rank_5] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_5` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 5 name to be %s", factionid, FactionData[factionid][Faction_Rank_5]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 6:
			    {
			        FactionData[factionid][Faction_Rank_6] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_6` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 6 name to be %s", factionid, FactionData[factionid][Faction_Rank_5]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			}
		}
	}
	return 1;
}

CMD:fdelete(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;
		new acquery[2000], dstring[256], value[20];

		if(sscanf(params, "iis[20]", factionid))
		{
			SendPlayerServerMessage(playerid, " /fedit [factionid]");
		}
		else
		{
		    value = "";

		    FactionData[factionid][Faction_Name] = value;

  			FactionData[factionid][Faction_Rank_1] = value;
  			FactionData[factionid][Faction_Rank_2] = value;
  			FactionData[factionid][Faction_Rank_3] = value;
  			FactionData[factionid][Faction_Rank_4] = value;
  			FactionData[factionid][Faction_Rank_5] = value;
  			FactionData[factionid][Faction_Rank_6] = value;

  			FactionData[factionid][Faction_Join_Requests] = 0;


       		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_name` = '', `faction_rank_1` = '', `faction_rank_2` = '', `faction_rank_3` = '', `faction_rank_4` = '', `faction_rank_5` = '', `faction_rank_6` = '' WHERE `faction_id` = '%i' LIMIT 1", factionid);
			mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have delete Faction(ID: %i) from the system!", factionid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}
    
CMD:gmx(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    SendGlobalServerMessage("Attention All Players! - The server will be restarting in 5 minutes, please end your roleplay!");
	    SetTimer("SaveImportantParameters", 240000, false);
	    SetTimer("ServerRestart", 300000, false);
	}
	return 1;
}

CMD:globalchat(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /globalchat [0 - On | 1 = Off]");

    GLOBALCHAT = strval(params);

	if(GLOBALCHAT == 0)
	{
		GLOBALCHAT = 0;
		SendGlobalServerMessage("Attention All Players! - Global chat has been turned on. Use [/g(lobal) (text)]");
	}
	else if(GLOBALCHAT == 1)
	{
	    GLOBALCHAT = 1;
	    SendGlobalServerMessage("Attention All Players! - Global chat has now been turned off");
	}
	else return SendPlayerServerMessage(playerid, " /globalchat [0 - On | 1 = Off]");
	return 1;
}

CMD:ddnext(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `door_information` WHERE `door_outside_x` = '0' LIMIT 1");
		mysql_tquery(connection, query, "GetNextDoorValue");
	}
	return 1;
}

CMD:ddinfo(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid;

		if(sscanf(params, "i", doorid))
		{
			SendPlayerServerMessage(playerid, " /ddinfo [doorid]");
		}
		else
		{
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID that you have searched for: %i, has a name of: %s", doorid, DoorData[doorid][Door_Description]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddname(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid, value1[50];
		
		if(sscanf(params, "is", doorid, value1))
		{
			SendPlayerServerMessage(playerid, " /ddname [doorid] [door description]");
		}
		else
		{
		    DoorData[doorid][Door_Description] = value1;

			new query[2000];
   			mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_description` = '%s' WHERE `door_id` = '%i' LIMIT 1", value1, doorid);
   			mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID: %i, has had a name changed to: %s", doorid, DoorData[doorid][Door_Description]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddfaction(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid, value1;

		if(sscanf(params, "ii", doorid, value1))
		{
			SendPlayerServerMessage(playerid, " /ddname [doorid] [0 = public | 1 > 10 faction id]");
		}
		else
		{
		    DoorData[doorid][Door_Faction] = value1;

			new query[2000];
   			mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_faction` = '%i' WHERE `door_id` = '%i' LIMIT 1", value1, doorid);
   			mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID: %i, has had a faction status changed to: %i", doorid, DoorData[doorid][Door_Faction]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddedit(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid, value1;
		new Float:x, Float:y, Float:z, Float:a;
		new intid, vwid;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		
		intid = GetPlayerInterior(playerid);
		vwid = GetPlayerVirtualWorld(playerid);

		if(sscanf(params, "ii", doorid, value1))
		{
			SendPlayerServerMessage(playerid, " /ddedit [doorid] [value 1]");
			SendPlayerServerMessage(playerid, " (Note: Exterior (1), Interior (2))");
		}
		else
		{
		    switch (value1)
		    {
		        case 1:
		        {
		            DestroyDynamicPickup(DoorData[doorid][Door_Pickup_ID_Outside]);
		            
                    DoorData[doorid][Door_Outside_X] = x;
                    DoorData[doorid][Door_Outside_Y] = y;
                    DoorData[doorid][Door_Outside_Z] = z;
					DoorData[doorid][Door_Outside_A] = a;
					
                    DoorData[doorid][Door_Outside_Interior] = intid;
                    DoorData[doorid][Door_Outside_VW] = vwid;
                    
                    DoorData[doorid][Door_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,DoorData[doorid][Door_Outside_X], DoorData[doorid][Door_Outside_Y], DoorData[doorid][Door_Outside_Z]+0.3, -1);
                    
                    printf("%i", DoorData[doorid][Door_Pickup_ID_Outside]);
                    
                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_outside_x` = '%f', `door_outside_y` = '%f', `door_outside_z` = '%f', `door_outside_interior` = '%i', `door_outside_vw` ='%i', `door_outside_a` = '%f' WHERE `door_id` = '%i' LIMIT 1", DoorData[doorid][Door_Outside_X], DoorData[doorid][Door_Outside_Y], DoorData[doorid][Door_Outside_Z], DoorData[doorid][Door_Outside_Interior], DoorData[doorid][Door_Outside_VW], DoorData[doorid][Door_Outside_A], doorid);
		    		mysql_tquery(connection, query);
		    		
		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID: %i, has had the exterior location changed to your spot", doorid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 2:
		        {
		            DestroyDynamicPickup(DoorData[doorid][Door_Pickup_ID_Inside]);
		            
                    DoorData[doorid][Door_Inside_X] = x;
                    DoorData[doorid][Door_Inside_Y] = y;
                    DoorData[doorid][Door_Inside_Z] = z;
                    DoorData[doorid][Door_Inside_A] = a;

                    DoorData[doorid][Door_Inside_Interior] = intid;
                    DoorData[doorid][Door_Inside_VW] = vwid;
                    
                    DoorData[doorid][Door_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,DoorData[doorid][Door_Inside_X], DoorData[doorid][Door_Inside_Y], DoorData[doorid][Door_Inside_Z]+0.3, -1);
                    
                    printf("%i", DoorData[doorid][Door_Pickup_ID_Inside]);
                    
                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_inside_x` = '%f', `door_inside_y` = '%f', `door_inside_z` = '%f', `door_inside_interior` = '%i', `door_inside_vw` ='%i', `door_inside_a` = '%f' WHERE `door_id` = '%i' LIMIT 1", DoorData[doorid][Door_Inside_X], DoorData[doorid][Door_Inside_Y], DoorData[doorid][Door_Inside_Z], DoorData[doorid][Door_Inside_Interior], DoorData[doorid][Door_Inside_VW], DoorData[doorid][Door_Inside_A], doorid);
		    		mysql_tquery(connection, query);
		    		
		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID: %i, has had the interior location changed to your spot", doorid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
			}
		}
	}
	return 1;
}

CMD:dddelete(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new dvalue[50];
		new ddoorid = PlayerAtDoorID[playerid];
		
		if(!IsPlayerNearDynamicDoor(playerid) || ddoorid == 0)
		{
		    SendPlayerErrorMessage(playerid, " You are not standing next to a dynamic door!");
		    return 1;
		}
		else
  		{
			DestroyDynamicPickup(DoorData[ddoorid][Door_Pickup_ID_Outside]);
			DestroyDynamicPickup(DoorData[ddoorid][Door_Pickup_ID_Inside]);

			dvalue = "";

			DoorData[ddoorid][Door_Faction] = 0;
			DoorData[ddoorid][Door_Description] = dvalue;
			DoorData[ddoorid][Door_Outside_X] = 0;
	        DoorData[ddoorid][Door_Outside_Y] = 0;
	        DoorData[ddoorid][Door_Outside_Z] = 0;
	        DoorData[ddoorid][Door_Outside_A] = 0;
	        DoorData[ddoorid][Door_Outside_Interior] = 0;
	        DoorData[ddoorid][Door_Outside_VW] = 0;
	        DoorData[ddoorid][Door_Inside_X] = 0;
	        DoorData[ddoorid][Door_Inside_Y] = 0;
	        DoorData[ddoorid][Door_Inside_Z] = 0;
	        DoorData[ddoorid][Door_Inside_A] = 0;
	        DoorData[ddoorid][Door_Inside_Interior] = 0;
	        DoorData[ddoorid][Door_Inside_VW] = 0;

			new equery[2000];
	        mysql_format(connection, equery, sizeof(equery), "UPDATE `door_information` SET `door_outside_x` = '0', `door_outside_y` = '0', `door_outside_z` = '0', `door_outside_interior` = '0', `door_outside_vw` ='0', `door_inside_x` = '0', `door_inside_y` = '0', `door_inside_z` = '0', `door_inside_interior` = '0', `door_inside_vw` ='0', `door_faction` = '0', `door_description` = '', `door_outside_a` = '0', `door_inside_a` = '0' WHERE `door_id` = '%i' LIMIT 1", ddoorid);
	  		mysql_tquery(connection, equery);

    		new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Door ID: %i has been deleted", ddoorid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			PlayerAtDoorID[playerid] = 0;
		}
	}
	return 1;
}

CMD:hnext(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `house_information` WHERE `house_outside_x` = '0' LIMIT 1");
		mysql_tquery(connection, query, "GetNextHouseValue");
	}
	return 1;
}

CMD:hinfo(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid;

		if(sscanf(params, "i", houseid))
		{
			SendPlayerServerMessage(playerid, " /hinfo [houseid]");
		}
		else
		{
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID that you have searched for %i, has address: %s and owner: %s", houseid, HouseData[houseid][House_Address], HouseData[houseid][House_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:hedit(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid, value1;
		new Float:x, Float:y, Float:z, Float:a;
		new intid, vwid;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		intid = GetPlayerInterior(playerid);
		vwid = GetPlayerVirtualWorld(playerid);

		if(sscanf(params, "ii", houseid, value1))
		{
			SendPlayerServerMessage(playerid, " /hedit [houseid] [option]");
			SendPlayerServerMessage(playerid, " Options: [Exterior Door (1) | Interior Door (2) | Interior Spawn (3)]");
		}
		else
		{
		    switch (value1)
		    {
		        case 1:
		        {
		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Outside]);

                    HouseData[houseid][House_Outside_X] = x;
                    HouseData[houseid][House_Outside_Y] = y;
                    HouseData[houseid][House_Outside_Z] = z;
                    HouseData[houseid][House_Outside_A] = a;

                    HouseData[houseid][House_Outside_Interior] = intid;
                    HouseData[houseid][House_Outside_VW] = vwid;

                    if(HouseData[houseid][House_Outside_X] != 0 && HouseData[houseid][House_Sold] == 0)
			      	{
			     	    HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(1273, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], -1);
					}
			        if(HouseData[houseid][House_Outside_X] != 0 && HouseData[houseid][House_Sold] == 1)
			      	{
			     	    HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z]+0.3, -1);
					}

                    printf("%d", HouseData[houseid][House_Pickup_ID_Outside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_outside_x` = '%f', `house_outside_y` = '%f', `house_outside_z` = '%f', `house_outside_interior` = '%i', `house_outside_vw` ='%i', `house_outside_a` = '%f' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], HouseData[houseid][House_Outside_Interior], HouseData[houseid][House_Outside_VW], HouseData[houseid][House_Outside_A], houseid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the exterior location changed to your spot", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 2:
		        {
		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = x;
                    HouseData[houseid][House_Inside_Y] = y;
                    HouseData[houseid][House_Inside_Z] = z;
                    HouseData[houseid][House_Inside_A] = a;

                    HouseData[houseid][House_Inside_Interior] = intid;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], houseid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior location changed to your spot", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 3:
		        {
                    HouseData[houseid][House_Spawn_X] = x;
                    HouseData[houseid][House_Spawn_Y] = y;
                    HouseData[houseid][House_Spawn_Z] = z;

                    HouseData[houseid][House_Spawn_Interior] = intid;
                    HouseData[houseid][House_Spawn_VW] = vwid;

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` ='%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], houseid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior spawn location changed to your spot", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
			}
		}
	}
	return 1;
}

CMD:hpreset(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid, value1;

		if(sscanf(params, "ii", houseid, value1))
		{
			SendPlayerServerMessage(playerid, " /hpreset [houseid] [type]");
			SendPlayerServerMessage(playerid, " Options: [1 - 11]");
		}
		else
		{
		    switch (value1)
		    {
		        case 1: // Hobo House
		        {
		            HouseData[houseid][House_Preset_Type] = 1;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 1525.5525;
                    HouseData[houseid][House_Inside_Y] = -10.9513;
                    HouseData[houseid][House_Inside_Z] = 1002.0971;
                    HouseData[houseid][House_Inside_A] = 352.0820;

					HouseData[houseid][House_Price_Money] = 25000;
					HouseData[houseid][House_Price_Coins] = 8;

                    HouseData[houseid][House_Inside_Interior] = 3;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 1528.3827;
                    HouseData[houseid][House_Spawn_Y]  = -8.5750;
                    HouseData[houseid][House_Spawn_Z] = 1002.0971;

                    HouseData[houseid][House_Spawn_Interior] = 3;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
		        case 2: // Vank Hoff Hotel
		        {
		            HouseData[houseid][House_Preset_Type] = 2;
		            
		            // ----- SET INTERIOR LOCATION ----- //
		            
		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2233.8184;
                    HouseData[houseid][House_Inside_Y] = -1114.9176;
                    HouseData[houseid][House_Inside_Z] = 1050.8828;
                    HouseData[houseid][House_Inside_A] = 5.1923;

					HouseData[houseid][House_Price_Money] = 45000;
					HouseData[houseid][House_Price_Coins] = 14;

                    HouseData[houseid][House_Inside_Interior] = 5;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
					
					// ----- SET SPAWN LOCATION ----- //
					
					HouseData[houseid][House_Spawn_X] = 2232.1914;
                    HouseData[houseid][House_Spawn_Y]  = -1104.9011;
                    HouseData[houseid][House_Spawn_Z] = 1050.8903;

                    HouseData[houseid][House_Spawn_Interior] = 5;
                    HouseData[houseid][House_Spawn_VW] = houseid;
                    
			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 3: // Willowfield safehouse
		        {
		            HouseData[houseid][House_Preset_Type] = 3;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2282.3787;
                    HouseData[houseid][House_Inside_Y] = -1140.0758;
                    HouseData[houseid][House_Inside_Z] = 1050.8984;
                    HouseData[houseid][House_Inside_A] = 336.3182;

					HouseData[houseid][House_Price_Money] = 55000;
					HouseData[houseid][House_Price_Coins] = 17;

                    HouseData[houseid][House_Inside_Interior] = 11;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 2282.4150;
                    HouseData[houseid][House_Spawn_Y]  = -1134.6112;
                    HouseData[houseid][House_Spawn_Z] = 1050.8984;

                    HouseData[houseid][House_Spawn_Interior] = 11;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 4: // Verdant Bluffs safehouse
		        {
		            HouseData[houseid][House_Preset_Type] = 4;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2365.1892;
                    HouseData[houseid][House_Inside_Y] = -1135.0635;
                    HouseData[houseid][House_Inside_Z] = 1050.8750;
                    HouseData[houseid][House_Inside_A] = 359.6336;

					HouseData[houseid][House_Price_Money] = 96000;
					HouseData[houseid][House_Price_Coins] = 29;

                    HouseData[houseid][House_Inside_Interior] = 8;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 2359.3350;
                    HouseData[houseid][House_Spawn_Y]  = -1134.4221;
                    HouseData[houseid][House_Spawn_Z] = 1050.8750;

                    HouseData[houseid][House_Spawn_Interior] = 8;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 5: // Safe House 5
		        {
		            HouseData[houseid][House_Preset_Type] = 5;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2196.7158;
                    HouseData[houseid][House_Inside_Y] = -1204.6316;
                    HouseData[houseid][House_Inside_Z] = 1049.0234;
                    HouseData[houseid][House_Inside_A] = 79.9449;

					HouseData[houseid][House_Price_Money] = 90000;
					HouseData[houseid][House_Price_Coins] = 27;

                    HouseData[houseid][House_Inside_Interior] = 6;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 2199.7209;
                    HouseData[houseid][House_Spawn_Y]  = -1218.5067;
                    HouseData[houseid][House_Spawn_Z] = 1049.0234;

                    HouseData[houseid][House_Spawn_Interior] = 6;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 6: // Unknown safe house
		        {
		            HouseData[houseid][House_Preset_Type] = 6;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2317.8896;
                    HouseData[houseid][House_Inside_Y] = -1026.7435;
                    HouseData[houseid][House_Inside_Z] = 1050.2178;
                    HouseData[houseid][House_Inside_A] = 120.2141;

					HouseData[houseid][House_Price_Money] = 200000;
					HouseData[houseid][House_Price_Coins] = 60;

                    HouseData[houseid][House_Inside_Interior] = 9;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 2328.4888;
                    HouseData[houseid][House_Spawn_Y]  = -1008.9063;
                    HouseData[houseid][House_Spawn_Z] = 1054.7188;

                    HouseData[houseid][House_Spawn_Interior] = 9;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 7: // Safe House 7
		        {
		            HouseData[houseid][House_Preset_Type] = 7;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 2324.5269;
                    HouseData[houseid][House_Inside_Y] = -1149.2377;
                    HouseData[houseid][House_Inside_Z] = 1050.7101;
                    HouseData[houseid][House_Inside_A] = 265.5508;

					HouseData[houseid][House_Price_Money] = 250000;
					HouseData[houseid][House_Price_Coins] = 75;

                    HouseData[houseid][House_Inside_Interior] = 12;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 2339.7478;
                    HouseData[houseid][House_Spawn_Y]  = -1138.0513;
                    HouseData[houseid][House_Spawn_Z] = 1054.3047;

                    HouseData[houseid][House_Spawn_Interior] = 12;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 8: // Burglary house 1
		        {
		            HouseData[houseid][House_Preset_Type] = 8;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 235.2570;
                    HouseData[houseid][House_Inside_Y] = 1187.1456;
                    HouseData[houseid][House_Inside_Z] = 1080.2578;
                    HouseData[houseid][House_Inside_A] = 176.7323;

					HouseData[houseid][House_Price_Money] = 150000;
					HouseData[houseid][House_Price_Coins] = 45;

                    HouseData[houseid][House_Inside_Interior] = 3;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 225.1508;
                    HouseData[houseid][House_Spawn_Y]  = 1194.1019;
                    HouseData[houseid][House_Spawn_Z] = 1084.4141;

                    HouseData[houseid][House_Spawn_Interior] = 3;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 9: // Burglary house 4
		        {
		            HouseData[houseid][House_Preset_Type] = 9;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 226.7229;
                    HouseData[houseid][House_Inside_Y] = 1114.3054;
                    HouseData[houseid][House_Inside_Z] = 1080.9951;
                    HouseData[houseid][House_Inside_A] = 89.1946;

					HouseData[houseid][House_Price_Money] = 165000;
					HouseData[houseid][House_Price_Coins] = 50;

                    HouseData[houseid][House_Inside_Interior] = 5;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 240.7824;
                    HouseData[houseid][House_Spawn_Y]  = 1107.6669;
                    HouseData[houseid][House_Spawn_Z] = 1085.0391;

                    HouseData[houseid][House_Spawn_Interior] = 5;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 10: // Burglary house 5
		        {
		            HouseData[houseid][House_Preset_Type] = 10;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 295.1458;
                    HouseData[houseid][House_Inside_Y] = 1472.5273;
                    HouseData[houseid][House_Inside_Z] = 1080.2578;
                    HouseData[houseid][House_Inside_A] = 176.1794;

					HouseData[houseid][House_Price_Money] = 95000;
					HouseData[houseid][House_Price_Coins] = 29;

                    HouseData[houseid][House_Inside_Interior] = 15;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 304.6297;
                    HouseData[houseid][House_Spawn_Y]  = 1475.4583;
                    HouseData[houseid][House_Spawn_Z] = 1080.2578;

                    HouseData[houseid][House_Spawn_Interior] = 15;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
				case 11: // Burglary house 6
		        {
		            HouseData[houseid][House_Preset_Type] = 11;
		            
		            // ----- SET INTERIOR LOCATION ----- //

		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = 447.1181;
                    HouseData[houseid][House_Inside_Y] = 1397.3279;
                    HouseData[houseid][House_Inside_Z] = 1084.3047;
                    HouseData[houseid][House_Inside_A] = 177.5195;

					HouseData[houseid][House_Price_Money] = 86000;
					HouseData[houseid][House_Price_Coins] = 26;

                    HouseData[houseid][House_Inside_Interior] = 2;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.3, houseid);

                    printf("%d", HouseData[houseid][House_Pickup_ID_Inside]);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i, has had the interior and spawn point both updated", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);

					// ----- SET SPAWN LOCATION ----- //

					HouseData[houseid][House_Spawn_X] = 455.0581;
                    HouseData[houseid][House_Spawn_Y]  = 1400.7732;
                    HouseData[houseid][House_Spawn_Z] = 1084.3080;

                    HouseData[houseid][House_Spawn_Interior] = 2;
                    HouseData[houseid][House_Spawn_VW] = houseid;

			        new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i', `house_inside_a` = '%f', `house_spawn_x` = '%f', `house_spawn_y` = '%f', `house_spawn_z` = '%f', `house_spawn_interior` = '%i', `house_spawn_vw` = '%i', `house_preset_type` = '%i', `house_price_money` = '%i', `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], HouseData[houseid][House_Inside_A], HouseData[houseid][House_Spawn_X], HouseData[houseid][House_Spawn_Y], HouseData[houseid][House_Spawn_Z], HouseData[houseid][House_Spawn_Interior], HouseData[houseid][House_Spawn_VW], HouseData[houseid][House_Preset_Type], HouseData[houseid][House_Price_Money], HouseData[houseid][House_Price_Coins], houseid);
		    		mysql_tquery(connection, query);
				}
			}
		}
	}
	return 1;
}

CMD:hdelete(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new dvalue[50], avalue[150];

		if(!IsPlayerNearHouseDoor(playerid) || PlayerAtHouseID[playerid] == 0)
		{
		    SendPlayerErrorMessage(playerid, " You are not standing next to a dynamic house!");
		    return 1;
		}
		else
  		{
  		    new hdoorid = PlayerAtHouseID[playerid];
  		    
			DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
			DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Inside]);

			dvalue = "";
			avalue = "";

			HouseData[hdoorid][House_Price_Money] = 0;
			HouseData[hdoorid][House_Price_Coins] = 0;
			HouseData[hdoorid][House_Owner] = dvalue;
			HouseData[hdoorid][House_Address] = avalue;
			HouseData[hdoorid][House_Sold] = 0;
			HouseData[hdoorid][House_Alarm] = 0;
			HouseData[hdoorid][House_Lock] = 0;
			HouseData[hdoorid][House_Robbed] = 0;
			HouseData[hdoorid][House_Robbed_Value] = 0;
			HouseData[hdoorid][House_Spawn_X] = 0;
	        HouseData[hdoorid][House_Spawn_Y] = 0;
	        HouseData[hdoorid][House_Spawn_Z] = 0;
	        HouseData[hdoorid][House_Spawn_Interior] = 0;
	        HouseData[hdoorid][House_Spawn_VW] = 0;
			HouseData[hdoorid][House_Outside_X] = 0;
	        HouseData[hdoorid][House_Outside_Y] = 0;
	        HouseData[hdoorid][House_Outside_Z] = 0;
	        HouseData[hdoorid][House_Outside_A] = 0;
	        HouseData[hdoorid][House_Outside_Interior] = 0;
	        HouseData[hdoorid][House_Outside_VW] = 0;
	        HouseData[hdoorid][House_Preset_Type] = 0;
	        HouseData[hdoorid][House_Inside_X] = 0;
	        HouseData[hdoorid][House_Inside_Y] = 0;
	        HouseData[hdoorid][House_Inside_Z] = 0;
	        HouseData[hdoorid][House_Inside_A] = 0;
	        HouseData[hdoorid][House_Inside_Interior] = 0;
	        HouseData[hdoorid][House_Inside_VW] = 0;

			new equery[2000];
	        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_price_money` = '0', `house_price_coins` = '0', `house_owner` = '%s',`house_address` = '%s', `house_sold` = '0', `house_alarm` = '0', `house_lock` = '0', `house_robbed` = '0', `house_robbed_value` = '0', `house_spawn_x` = '0', `house_spawn_y` = '0', `house_spawn_z` = '0', `house_spawn_interior` = '0', `house_spawn_vw` = '0', `house_outside_x` = '0', `house_outside_y` = '0', `house_outside_z` = '0', `house_outside_interior` = '0', `house_outside_vw` = '0', `house_inside_x` = '0', `house_inside_y` = '0', `house_inside_z` = '0', `house_inside_interior` = '0', `house_inside_vw` = '0', `house_preset_type` = '0' WHERE `house_id` = '%i' LIMIT 1", dvalue, avalue, hdoorid);
	  		mysql_tquery(connection, equery);

    		new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The House ID: %i has been deleted", hdoorid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			PlayerAtHouseID[playerid] = 0;
		}
	}
	return 1;
}

CMD:hsetaddress(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid, value[150];

		if(sscanf(params, "is", houseid, value))
		{
			SendPlayerServerMessage(playerid, " /hsetaddress [houseid] [value]");
		}
		else
		{
		    HouseData[houseid][House_Address] = value;
		    
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated House ID: %i address to be %s", houseid, HouseData[houseid][House_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			new equery[2000];
   			mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_address` = '%s' WHERE `house_id` = '%i' LIMIT 1", value, houseid);
			mysql_tquery(connection, equery);
		}
	}
	return 1;
}

CMD:hsetcost(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid, option1, value;

		if(sscanf(params, "iii", houseid, option1, value))
		{
			SendPlayerServerMessage(playerid, " /sethousecost [houseid] [option] [value]");
			SendPlayerServerMessage(playerid, " Options: [Coins (1) | Money (2)]");
		}
		else
		{
		    switch(option1)
		    {
		        case 1:
		        {
		            HouseData[houseid][House_Price_Coins] = value;

		            new equery[2000];
			        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_price_coins` = '%i' WHERE `house_id` = '%i' LIMIT 1", value, houseid);
			  		mysql_tquery(connection, equery);
		        
		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} House ID: %i has been updated with a new coin cost of: %i", houseid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		        case 2:
		        {
		            HouseData[houseid][House_Price_Money] = value;

		            new equery[2000];
			        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_price_money` = '%i' WHERE `house_id` = '%i' LIMIT 1", value, houseid);
			  		mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} House ID: %i has been updated with a new money cost of: %i", houseid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		    }
		}
	}
	return 1;
}

CMD:hsetowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new houseid, targetid;

		if(sscanf(params,"ii", targetid, houseid))
		{
		    SendPlayerServerMessage(playerid, " /hsetowner [player id] [house id]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
		        DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Outside]);
		        HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], -1);

			    new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '%e', `house_sold` = '1' WHERE `house_id` = '%i' LIMIT 1", PlayerData[targetid][Character_Name], houseid);
				mysql_tquery(connection, equery);
				
				new namestring[50];
				namestring = GetName(targetid);
				
				HouseData[houseid][House_Owner] = namestring;
				HouseData[houseid][House_Sold] = 1;
				
		    	printf("%s", namestring);

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set player(ID: %i, Name: %s) owner of property id: %i", targetid, PlayerData[targetid][Character_Name], houseid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "> You have just been given ownership of property %s", HouseData[houseid][House_Address]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

CMD:hremoveowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new houseid, targetid;

		if(sscanf(params,"ii", targetid, houseid))
		{
		    SendPlayerServerMessage(playerid, " /hremoveowner [player id] [house id]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
		        DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Outside]);
		        HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(1273, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], -1);

			    new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '', `house_sold` = '0' WHERE `house_id` = '%i' LIMIT 1", PlayerData[targetid][Character_Name], houseid);
				mysql_tquery(connection, equery);

				new namestring[50];
				namestring = "";

				HouseData[houseid][House_Owner] = namestring;
				HouseData[houseid][House_Sold] = 0;

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just removed player(ID: %i, Name: %s) from house id: %i", targetid, PlayerData[targetid][Character_Name], houseid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "> An admin has just removed you from property: %s", HouseData[houseid][House_Address]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

CMD:bnext(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `business_information` WHERE `business_outside_x` = '0' LIMIT 1");
		mysql_tquery(connection, query, "GetNextBusinessID");
	}
	return 1;
}

CMD:binfo(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new businessid;

		if(sscanf(params, "i", businessid))
		{
			SendPlayerServerMessage(playerid, " /binfo [businessid]");
		}
		else
		{
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID that you have searched for %i, is named: %s and owned by: %s", businessid, BusinessData[businessid][Business_Name], BusinessData[businessid][Business_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:bedit(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new businessid, value1;
		new Float:x, Float:y, Float:z, Float:a;
		new intid, vwid;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		intid = GetPlayerInterior(playerid);
		vwid = GetPlayerVirtualWorld(playerid);

		if(sscanf(params, "ii", businessid, value1))
		{
			SendPlayerServerMessage(playerid, " /bedit [businessid] [option]");
			SendPlayerServerMessage(playerid, " Options: [Exterior Door (1) | Interior Door (2) | Buy Point (3)");
		}
		else
		{
		    switch (value1)
		    {
		        case 1:
		        {
		            DestroyDynamicPickup(BusinessData[businessid][Business_Pickup_ID_Outside]);

                    BusinessData[businessid][Business_Outside_X] = x;
                    BusinessData[businessid][Business_Outside_Y] = y;
                    BusinessData[businessid][Business_Outside_Z] = z;
                    BusinessData[businessid][Business_Outside_A] = a;

                    BusinessData[businessid][Business_Outside_Interior] = intid;
                    BusinessData[businessid][Business_Outside_VW] = vwid;

                    if(BusinessData[businessid][Business_Outside_X] != 0 && BusinessData[businessid][Business_Sold] == 0)
			      	{
			     	    BusinessData[businessid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19523, 1,BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z], -1);
					}
			        if(BusinessData[businessid][Business_Outside_X] != 0 && BusinessData[businessid][Business_Sold] == 1)
			      	{
			     	    BusinessData[businessid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z]+0.5, -1);
					}

                    printf("%i", BusinessData[businessid][Business_Pickup_ID_Outside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `business_information` SET `business_outside_x` = '%f', `business_outside_y` = '%f', `business_outside_z` = '%f', `business_outside_interior` = '%i', `business_outside_vw` ='%i', `business_outside_a` = '%f' WHERE `business_id` = '%i' LIMIT 1", BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z], BusinessData[businessid][Business_Outside_Interior], BusinessData[businessid][Business_Outside_VW], BusinessData[businessid][Business_Outside_A], businessid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID: %i, has had the exterior location changed to your spot", businessid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 2:
		        {
		            DestroyDynamicPickup(BusinessData[businessid][Business_Pickup_ID_Inside]);

                    BusinessData[businessid][Business_Inside_X] = x;
                    BusinessData[businessid][Business_Inside_Y] = y;
                    BusinessData[businessid][Business_Inside_Z] = z;
                    BusinessData[businessid][Business_Inside_A] = a;

                    BusinessData[businessid][Business_Inside_Interior] = intid;
                    BusinessData[businessid][Business_Inside_VW] = businessid;

                    BusinessData[businessid][Business_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,BusinessData[businessid][Business_Inside_X], BusinessData[businessid][Business_Inside_Y], BusinessData[businessid][Business_Inside_Z]+0.5, businessid);

                    printf("%i", BusinessData[businessid][Business_Pickup_ID_Inside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `business_information` SET `business_inside_x` = '%f', `business_inside_y` = '%f', `business_inside_z` = '%f', `business_inside_interior` = '%i', `business_inside_vw` ='%i', `business_inside_a` = '%f' WHERE `business_id` = '%i' LIMIT 1", BusinessData[businessid][Business_Inside_X], BusinessData[businessid][Business_Inside_Y], BusinessData[businessid][Business_Inside_Z], BusinessData[businessid][Business_Inside_Interior], BusinessData[businessid][Business_Inside_VW], BusinessData[businessid][Business_Inside_A], businessid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID: %i, has had the interior location changed to your spot", businessid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
    			}
    			case 3:
			   {
			        BusinessData[businessid][Business_BuyPoint_X] = x;
                    BusinessData[businessid][Business_BuyPoint_Y] = y;
                    BusinessData[businessid][Business_BuyPoint_Z] = z;

                    CreateDynamicPickup(1274, 1,BusinessData[businessid][Business_BuyPoint_X], BusinessData[businessid][Business_BuyPoint_Y], BusinessData[businessid][Business_BuyPoint_Z], businessid);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `business_information` SET `business_buypoint_x` = '%f', `business_buypoint_y` = '%f', `business_buypoint_z` = '%f' WHERE `business_id` = '%i' LIMIT 1", BusinessData[businessid][Business_BuyPoint_X], BusinessData[businessid][Business_BuyPoint_Y], BusinessData[businessid][Business_BuyPoint_Z], businessid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID: %i, has had this business buy point changed to your spot", businessid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			   }
			}
		}
	}
	return 1;
}

CMD:bdelete(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new dvalue[50], avalue[50];

		if(!IsPlayerNearBusinessDoor(playerid) || PlayerAtBusinessID[playerid] == 0)
		{
		    SendPlayerErrorMessage(playerid, " You are not standing next to a dynamic business!");
		    return 1;
		}
		else
  		{
  		    new bdoorid = PlayerAtBusinessID[playerid];

			DestroyDynamicPickup(BusinessData[bdoorid][Business_Pickup_ID_Outside]);
			DestroyDynamicPickup(BusinessData[bdoorid][Business_Pickup_ID_Inside]);

			dvalue = "";
			avalue = "";

			BusinessData[bdoorid][Business_Price_Money] = 0;
			BusinessData[bdoorid][Business_Price_Coins] = 0;
			BusinessData[bdoorid][Business_Owner] = dvalue;
			BusinessData[bdoorid][Business_Name] = avalue;
			BusinessData[bdoorid][Business_Sold] = 0;
			BusinessData[bdoorid][Business_Alarm] = 0;
			BusinessData[bdoorid][Business_Type] = 0;
			BusinessData[bdoorid][Business_Robbed] = 0;
			BusinessData[bdoorid][Business_Robbed_Value] = 0;
			BusinessData[bdoorid][Business_Outside_X] = 0;
	        BusinessData[bdoorid][Business_Outside_Y] = 0;
	        BusinessData[bdoorid][Business_Outside_Z] = 0;
	        BusinessData[bdoorid][Business_Outside_A] = 0;
	        BusinessData[bdoorid][Business_Outside_Interior] = 0;
	        BusinessData[bdoorid][Business_Outside_VW] = 0;
	        BusinessData[bdoorid][Business_Inside_X] = 0;
	        BusinessData[bdoorid][Business_Inside_Y] = 0;
	        BusinessData[bdoorid][Business_Inside_Z] = 0;
	        BusinessData[bdoorid][Business_Inside_A] = 0;
	        BusinessData[bdoorid][Business_Inside_Interior] = 0;
	        BusinessData[bdoorid][Business_Inside_VW] = 0;

			new equery[2000];
	        mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_price_money` = '0', `business_price_coins` = '0', `business_owner` = '%s',`business_name` = '%s', `business_sold` = '0', `business_alarm` = '0', `business_type` = '0', `business_robbed` = '0', `business_robbed_value` = '0', `business_outside_x` = '0', `business_outside_y` = '0', `business_outside_z` = '0', `business_outside_interior` = '0', `business_outside_vw` = '0', `business_inside_x` = '0', `business_inside_y` = '0', `business_inside_z` = '0', `business_inside_interior` = '0', `business_inside_vw` = '0' WHERE `business_id` = '%i' LIMIT 1", dvalue, avalue, bdoorid);
	  		mysql_tquery(connection, equery);

    		new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID: %i has been deleted", bdoorid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			PlayerAtBusinessID[playerid] = 0;
		}
	}
	return 1;
}

CMD:bsetname(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new businessid, value[50];

		if(sscanf(params, "is", businessid, value))
		{
			SendPlayerServerMessage(playerid, " /bsetname [businessid] [value]");
		}
		else
		{
		    BusinessData[businessid][Business_Name] = value;

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have updated Business ID: %i name to be %s", businessid, BusinessData[businessid][Business_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			new equery[2000];
		    mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_name` = '%s' WHERE `business_id` = '%i' LIMIT 1", value, businessid);
			mysql_tquery(connection, equery);
		}
	}
	return 1;
}

CMD:bsetcost(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
    if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new businessid, option1, value;

		if(sscanf(params, "iii", businessid, option1, value))
		{
			SendPlayerServerMessage(playerid, " /bsetcost [businessid] [option] [value]");
			SendPlayerServerMessage(playerid, " Options: [Coins (1) | Money (2)]");
		}
		else
		{
		    switch(option1)
		    {
		        case 1:
		        {
		            BusinessData[businessid][Business_Price_Coins] = value;
			
					new equery[2000];
		      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_price_coins` = '%i' WHERE `business_id` = '%i' LIMIT 1", value, businessid);
					mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} Business ID: %i has been updated with a new coin cost of: %i", businessid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		        case 2:
		        {
		            BusinessData[businessid][Business_Price_Money] = value;
			
					new equery[2000];
		      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_price_money` = '%i' WHERE `business_id` = '%i' LIMIT 1", value, businessid);
					mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} Business ID: %i has been updated with a new money cost of: %i", businessid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		    }
		}
	}
	return 1;
}

CMD:bsettype(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new businessid, biztype;

		if(sscanf(params,"ii", businessid, biztype))
		{
		    SendPlayerServerMessage(playerid, " /bsettype [businessid] [type]");
		    SendPlayerServerMessage(playerid, " Options: [24/7 (1) | Supermarket (2) | Electronic Store (3)]");
		    SendPlayerServerMessage(playerid, " Options: [Food (4) | Bar (5) | Clothing 1 (6) | Ammunation (7)]");
		    SendPlayerServerMessage(playerid, " Options: [Donuts (8) | Clothing 2 (9) | Dealership 1 (10) | Dealership 2 (11)]");
		    SendPlayerServerMessage(playerid, " Options: [Bike Shop (12)]");
		}
		else
		{
		    if(biztype < 1 || biztype > 20) return SendPlayerErrorMessage(playerid, " You need to select a valid business type ID that can be used in-game!");
		    else
		    {
				BusinessData[businessid][Business_Type] = biztype;

		    	new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_type` = '%i' WHERE `business_id` = '%i' LIMIT 1", BusinessData[businessid][Business_Type], businessid);
				mysql_tquery(connection, equery);

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} The Business ID: %i, has had the business type changed to status: %i", businessid, BusinessData[businessid][Business_Type]);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);
			}
		}
	}
	return 1;
}

CMD:bsetowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new businessid, targetid;

		if(sscanf(params,"ii", targetid, businessid))
		{
		    SendPlayerServerMessage(playerid, " /bsetowner [player id] [busines id]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
		        DestroyDynamicPickup(BusinessData[businessid][Business_Pickup_ID_Outside]);
		        BusinessData[businessid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z]+0.3, -1);

			    new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_owner` = '%e', `business_sold` = '1' WHERE `business_id` = '%i'", PlayerData[targetid][Character_Name], businessid);
				mysql_tquery(connection, equery);

				new namestring[50];
				namestring = GetName(targetid);

				BusinessData[businessid][Business_Owner] = namestring;
				BusinessData[businessid][Business_Sold] = 1;

		    	printf("%s", namestring);

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just set player(ID: %i, Name: %s) owner of business id: %i", targetid, PlayerData[targetid][Character_Name], businessid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "> You have just been given ownership of business %s", BusinessData[businessid][Business_Name]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

CMD:bremoveowner(playerid, params[])
{
	if(IsPlayerLogged[playerid] == 0) return SendPlayerErrorMessage(playerid, " You need to be logged in before using this command!");
	if(PlayerData[playerid][Admin_Level] < 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new businessid, targetid;

		if(sscanf(params,"ii", targetid, businessid))
		{
		    SendPlayerServerMessage(playerid, " /bremoveowner [player id] [business id]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
		        DestroyDynamicPickup(BusinessData[businessid][Business_Pickup_ID_Outside]);
		        BusinessData[businessid][Business_Pickup_ID_Outside] = CreateDynamicPickup(19523, 1,BusinessData[businessid][Business_Outside_X], BusinessData[businessid][Business_Outside_Y], BusinessData[businessid][Business_Outside_Z], -1);
				
			    new equery[2000];
	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `business_information` SET `business_owner` = '0', `business_sold` = '0' WHERE `business_id` = '%i' LIMIT 1", businessid);
				mysql_tquery(connection, equery);

				new namestring[50];
				namestring = "";

				BusinessData[businessid][Business_Owner] = namestring;
				BusinessData[businessid][Business_Sold] = 0;

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:{FFFFFF} You have just removed player(ID: %i, Name: %s) from business id: %i", targetid, PlayerData[targetid][Character_Name], businessid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "> An admin has just removed you from business: %s", BusinessData[businessid][Business_Name]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

