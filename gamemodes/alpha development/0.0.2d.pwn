/* ------ CREDITS DUE ------ */
/*
		iAmir - loop bug error assitance
		y_less - ini parse bug assistance / reported
		cessil - just because he wants too
*/
/* ------ INCLUDES ------- */

#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <foreach>
#include <a_mysql>
#include <string_new>

#include "Maps/RemoveBuildings.pwn"
#include "Maps/Maps.pwn"

/* ------ SERVER STATIC INFORMATION ------- */

#define 	SERVER_NAME 		"Golden Roleplay - New Release Open.mp"
#define 	SERVER_VERSION 		"0.0.2d"
#define     SERVER_MODE         "Roleplay"
#define 	SERVER_MAPNAME  	"Los Santos"

#define 	SERVER_INT_WEATHER 	"1"
#define 	SERVER_INT_TIME 	"12"

/* ------ SQL CONNECTION INFORMATION ------- */

#define 	SQL_SERVER 			"localhost"
#define 	SQL_USER 			"root"
#define 	SQL_PASSWORD 		""
#define 	SQL_DB 				"goldenroleplay"

new connection = -1;

/* ------ GENERAL INFORMATION ------- */

// COLOR DEFINES
#define 	COLOR_WHITE  		0xFFFFFFFF
#define 	COLOR_RED   		0xFF000000
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

#define SendPlayerServerMessage(%0,%1) \
	SendClientMessage(%0, COLOR_ORANGE, "[SERVER]:{FFFFFF} "%1)

#define SendPlayerErrorMessage(%0,%1) \
	SendClientMessage(%0, COLOR_PINK, "[ERROR]:{FFFFFF} "%1)
	
#define SendGlobalServerMessage(%1) \
	SendClientMessageToAll(COLOR_ORANGE, "[GLOBAL SERVER]:{FFFFFF} "%1)
	
#define SendGlobalErrorMessage(%1) \
	SendClientMessageToAll(COLOR_PINK, "[GLOBAL ERROR]:{FFFFFF} "%1)

// DIALOG DEFINES
#define 	DIALOG_LOGIN			1
#define 	DIALOG_REGISTER			2
#define 	DIALOG_REGISTER_EMAIL   3
#define 	DIALOG_REGISTER_AGE     4
#define 	DIALOG_REGISTER_SEX     5
#define 	DIALOG_REGISTER_BP      6
#define 	DIALOG_REGISTER_END     7

#define 	DIALOG_GUIDE_LIST     	10
#define 	DIALOG_GUIDE_JOBS     	11
#define 	DIALOG_GUIDE_FACTIONS  	12
#define 	DIALOG_GUIDE_COMMANDS  	13
#define 	DIALOG_GUIDE_VEHICLES  	14
#define 	DIALOG_GUIDE_HOUSES    	15
#define 	DIALOG_GUIDE_ADMINS    	16

#define     DIALOG_COMMANDS_MAIN    20
#define     DIALOG_COMMANDS_GENERAL 21
#define     DIALOG_COMMANDS_FACTION 22
#define     DIALOG_COMMANDS_HOUSE   23
#define     DIALOG_COMMANDS_BIZZ    24
#define     DIALOG_COMMANDS_JOB	    25
#define     DIALOG_COMMANDS_ADMIN   26

#define 	MAX_DOORS       		200
#define 	MAX_HOUSES       		200
#define     MAX_FACTIONS            20
 
// USER DEFINES
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
    Character_Skin,
    
    Character_Faction,
    Character_Faction_Rank,
    Character_Faction_Join_Request,

	Character_Money,
	Character_Coins,
	Character_VIP,

    Float:Character_Pos_X,
    Float:Character_Pos_Y,
    Float:Character_Pos_Z,
    Float:Character_Pos_Angle,
    Character_Interior_ID,
    Character_Virtual_World,
	
	Admin_Level,
	Admin_Level_Exp
};
new PlayerData[MAX_PLAYERS][playerInfo];

// FACTION DEFINES
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
	
	Faction_Join_Requests
};
new FactionData[MAX_FACTIONS][factionInfo];

// HOUSE DEFINES

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
};
new HouseData[MAX_HOUSES][houseInfo];

// DOOR DEFINES

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
	Door_Outside_VW,
};
new DoorData[MAX_DOORS][doorInfo];

// GENERAL SCRIPT REFERENCES

new Float:InfoPickups[][] =
{
    {1439.3849,-2293.1267,13.5469}, // /HELP ICON
	{1439.5317,-2281.4648,13.5469}, // /TUTORIALICON
	{1418.1593,-2311.6946,13.9298}, // /RENTCAR ICON
	{-1876.2999,50.1774,1055.1891}, // /GUIDE ICON
	{254.2574,76.7777,1003.6406}, // /DUTY LSPD ICON
	{257.8931,77.9195,1003.6406}, // /SWAT LSPD ICON
	{325.8665,306.9962,999.1484}, // /DUTY SECURITY ICON
	{1808.8501,-1898.7998,13.5790} // /JOB - TAXI
};

new SERVER_HOUR;
new SERVER_MINUTE;
new SERVER_SECOND;
new GLOBALCHAT;

new SQL_DOOR_NEXTID;
new SQL_HOUSE_NEXTID;
new SQL_FACTION_NEXTID;

new IsPlayerLogged[MAX_PLAYERS];
new IsPlayerMuted[MAX_PLAYERS];

new PlayerAtDoorID[MAX_PLAYERS];
new PlayerAtHouseID[MAX_PLAYERS];

// TEXTDRAW REFERNCES
new Text:Time;
new PlayerText:Notification_Textdraw;

// SERVER TIMERS
new Notfication_Timer[MAX_PLAYERS];

/*-----------------------------------------------------------------------------
						INITIAL GAMEMODE CODE STARTS HERE
-----------------------------------------------------------------------------*/
main(){}
 
public OnGameModeInit()
{
	
    SetGameModeText(SERVER_MODE);
	
	mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML);
    connection = mysql_connect(SQL_SERVER, SQL_USER, SQL_DB, SQL_PASSWORD);
    
	ShowPlayerMarkers(0);
	ShowNameTags(1);
	SetNameTagDrawDistance(6.0);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
    ManualVehicleEngineAndLights();
    
    LoadAllMaps();
    LoadDoors();
    LoadHouses();
    LoadFactions();
    
    Time = TextDrawCreate(576.963073, 24.533348, "01:40");
	TextDrawLetterSize(Time, 0.487145, 1.582499);
	TextDrawAlignment(Time, 2);
	TextDrawColor(Time, -1);
	TextDrawSetShadow(Time, 0);
	TextDrawSetOutline(Time, 2);
	TextDrawBackgroundColor(Time, 255);
	TextDrawFont(Time, 3);
	TextDrawSetProportional(Time, 1);
	TextDrawSetShadow(Time, 0);
	
	SERVER_SECOND = 00;
	SERVER_MINUTE = 00;
	SERVER_HOUR = 00;
	
	GLOBALCHAT = 1;

	for(new i; i<sizeof InfoPickups; i++)
	{
	   AddStaticPickup(1239, 1,InfoPickups[i][0], InfoPickups[i][1], InfoPickups[i][2], -1);
	}
	
	SetTimer("SERVER_ONESEC_TIMER", 1000, 1);
    
    return 1;
}
 
public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        OnPlayerDisconnect(i, 1);
    }
    mysql_close(connection);
    return 1;
}
 
public OnPlayerRequestClass(playerid, classid)
{
	TogglePlayerSpectating(playerid, 1);
	
	InterpolateCameraPos(playerid, -17.8958, 1214.2452, 22.9738, -20.1276, 1214.2823, 22.9738, 6000,CAMERA_MOVE);
 	InterpolateCameraLookAt(playerid, -63.2371, 1183.7734, 18.5250, -63.2371, 1183.7734, 18.5250, 6000,CAMERA_MOVE);
	return 1;
}
 
public OnPlayerConnect(playerid)
{
    Notification_Textdraw = CreatePlayerTextDraw(playerid,500.000000, 114.000000, "");
	PlayerTextDrawBackgroundColor(playerid,Notification_Textdraw, 255);
	PlayerTextDrawFont(playerid,Notification_Textdraw, 1);
	PlayerTextDrawLetterSize(playerid,Notification_Textdraw, 0.220000, 1.200000);
	PlayerTextDrawColor(playerid,Notification_Textdraw, -1);
	PlayerTextDrawSetOutline(playerid,Notification_Textdraw, 0);
	PlayerTextDrawSetProportional(playerid,Notification_Textdraw, 1);
	PlayerTextDrawSetShadow(playerid,Notification_Textdraw, 1);
	PlayerTextDrawUseBox(playerid,Notification_Textdraw, 1);
	PlayerTextDrawBoxColor(playerid,Notification_Textdraw, 255);
	PlayerTextDrawTextSize(playerid,Notification_Textdraw, 606.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid,Notification_Textdraw, 0);
	PlayerTextDrawHide(playerid, PlayerText:Notification_Textdraw);
	
    new query[128];
    GetPlayerName(playerid, PlayerData[playerid][Character_Name], MAX_PLAYER_NAME);
    
    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, query, "OnAccountCheck", "i", playerid);
 
    IsPlayerLogged[playerid] = 0;
    IsPlayerMuted[playerid] = 0;
    
    PlayerAtDoorID[playerid] = 0;
    PlayerAtHouseID[playerid] = 0;

	RemoveBuildings(playerid);
    
    return 1;
}
 
public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerLogged[playerid] == 0) return 0;
    
    SaveUserInformation(playerid);
    
    PlayerData[playerid][Character_Age] = 0;
    PlayerData[playerid][Character_Sex] = 0;
    PlayerData[playerid][Character_Birthplace] = 0;
    PlayerData[playerid][Character_Registered] = 0;
    PlayerData[playerid][Character_Skin] = 0;
    
    PlayerData[playerid][Character_Faction] = 0;
    PlayerData[playerid][Character_Faction_Rank] = 0;
    PlayerData[playerid][Character_Faction_Join_Request] = 0;
    
    PlayerData[playerid][Character_Money] = 0;
    PlayerData[playerid][Character_Coins] = 0;
    PlayerData[playerid][Character_VIP] = 0;

    PlayerData[playerid][Character_Pos_X] = 0;
    PlayerData[playerid][Character_Pos_Y] = 0;
    PlayerData[playerid][Character_Pos_Z] = 0;
    PlayerData[playerid][Character_Pos_Angle] = 0;
    PlayerData[playerid][Character_Interior_ID] = 0;
    PlayerData[playerid][Character_Virtual_World] = 0;

    PlayerData[playerid][Admin_Level] = 0;
    PlayerData[playerid][Admin_Level_Exp] = 0;
    
    return 1;
}
 
public OnPlayerSpawn(playerid)
{
    return 1;
}
 
public OnPlayerDeath(playerid, killerid, reason)
{
 
    //mysql Account save
    if(killerid == INVALID_PLAYER_ID) return 0;
    if(IsPlayerLogged[killerid] == 0) return 0;
    if(IsPlayerLogged[playerid] == 0) return 0;
//    PlayerData[killerid][Kills]++;
   // PlayerData[playerid][Deaths]++;
    return 1;
}
 
public OnVehicleSpawn(vehicleid)
{
    return 1;
}
 
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(IsPlayerMuted[playerid] == 1) return SendPlayerErrorMessage(playerid, " You have been muted temp, please wait for an unmute!");
    if(!success) SendPlayerErrorMessage(playerid, " This command doesn't exist in our system, please use /commands for more info!");
	return 1;
}
 
public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}
 
public OnPlayerText(playerid, text[])
{
	new message[128];
 	format(message, sizeof(message), "%s says: %s", GetName(playerid), text);
	ProxDetector(30.0, playerid, message, -1,-1,-1,-1,-1);
    return 0;
}
 
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid,bodypart)
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
 
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    return 1;
}
 
public OnPlayerEnterCheckpoint(playerid)
{
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
 
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SECONDARY_ATTACK)
    {
  		DynamicDoorEntry(playerid);
    }
    return 1;
}
 
public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}
 
public OnPlayerUpdate(playerid)
{
	CheckUserMoney(playerid);

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

				    TogglePlayerSpectating(playerid, 0);
				    
				    ClearMessages(playerid);

					LoginSpawn(playerid);
				}
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Golden Roleplay - Login", "This account has been registered before and\nyou have not provided the correct password.\n\nPlease provide the password required:", "Login", "Quit");
	        }
	    }
	    case DIALOG_REGISTER:
	    {
	        if(!response) return Kick(playerid);
	        if(strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Golden Roleplay - Registration", "(You did not provide a long enough password to continue)\n\nThis account has not been registered before on this server.\n\nPlease enter in a password that you will remember.", "Register", "Quit");
			
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
			        case 0: { stext = "Male"; PlayerData[playerid][Character_Skin] = SetPlayerSkin(playerid, 2); }
			        case 1: { stext = "Female"; PlayerData[playerid][Character_Skin] = SetPlayerSkin(playerid, 41); }
			        case 2: { stext = "Non-Binary"; PlayerData[playerid][Character_Skin] = SetPlayerSkin(playerid, 252);}
			        case 3: { stext = "Transgender"; PlayerData[playerid][Character_Skin] = SetPlayerSkin(playerid, 256);}
			        case 4: { stext = "Ghost"; PlayerData[playerid][Character_Skin] = SetPlayerSkin(playerid, 264); }
			    }
			    
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
	        mysql_format(connection, acquery, sizeof(acquery), "UPDATE `user_accounts` SET `account_email` = '%s', `character_registered` = '%i', `character_age` = '%i',`character_sex` = '%s',`character_birthplace` ='%s', `character_skin` ='%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Account_Email], PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Skin], PlayerData[playerid][Character_Name]);
    		mysql_tquery(connection, acquery);

			TogglePlayerSpectating(playerid, 0);
	        
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
		            case 0: { ShowPlayerDialog(playerid, DIALOG_GUIDE_JOBS, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Jobs", "This server holds many jobs within the roleplay network.\n\n Some of those jobs include:\n\n1. Pizza Driver\n2. Tow Truck Driver\n3. Truck Driver\n4. Detective\n5. Gunsmith\n6. Drug Dealer\n\n What ever you pick, will be you characters life they will roleplay.\n\n\n(For more assistance or help, please use command /staffrequest)", "Close", ""); }
		            case 1: { ShowPlayerDialog(playerid, DIALOG_GUIDE_FACTIONS, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Factions", "This server holds many factions within the roleplay network.\nMany people ask, 'do i need to register on the forum to join one?' The answer is simple 'No', you can apply in-game to join factions.\n\n Some of those factions include:\n\n1. LSPD\n2. LSFD\n3. DMV\n4. LS Bank\n5. Dudefix .Co\n6. Mechanic\n\n What ever you pick, will be you characters life they will roleplay.\n\n\n(For more assistance or help, please use command /staffrequest)", "Close", ""); }
		            case 2: { ShowPlayerDialog(playerid, DIALOG_GUIDE_COMMANDS, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Commands", "There are alot of commands for this server, due to the ammount you can view these all by typing /commands\n\nStarting roleplay commands are:\n\n1. /me - roleplay the actions of the user\n2. /do - asks the response of the action or result of the said action\n3. /ooc - local out of character chat\n4. /global - server network public chat for all users to communicate out of character wise", "Close", ""); }
		            case 3: { ShowPlayerDialog(playerid, DIALOG_GUIDE_VEHICLES, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Vehicles", "Within this server we have standard vehicles placed throughout the city to help with daily life. Sadly,\nthese vehicles are not player owned and if pulled over in one could get you arrested.\n\nYou can buy or rent vehicles from our local dealerships, these can be found with the GPS system\nwithin your cellphone.", "Close", ""); }
		            case 4: { ShowPlayerDialog(playerid, DIALOG_GUIDE_HOUSES, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Houses", "We have many features within this server and houses for players to buy is one of them.\n\nThere are currently 200 houses within the server and all are custom built with either basic interiors or custom mapped ones depending on location.\nIf you want to view a house, all you need to do is, go up to a green pickup icon and type /purchaseproperty\n\nYou can also sell your property by standing next to your hosue and typing /sellproperty [amount]", "Close", ""); }
		            case 5: { ShowPlayerDialog(playerid, DIALOG_GUIDE_ADMINS, DIALOG_STYLE_MSGBOX, "Golden Roleplay Guide - Admins", "Due to we are in early stages of development, this project will host many types of admins from different locations.\n\nPlease take note that this is volunteer basis and noone is getting paid to be here.\nPlease respect all admins and staff and have a great time on our server.", "Close", ""); }
		        }
		    }
		}
	}
    return 1;
}
 
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
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
	SpawnPlayer(playerid);
    if(cache_num_rows() > 0)
    {
        // ----- Account Stats ------ //
		PlayerData[playerid][Account_ID] = cache_get_field_content_int(0, "account_id");
		cache_get_field_content(0, "account_email", PlayerData[playerid][Account_Email], connection, 129);
		PlayerData[playerid][Account_IP] = cache_get_field_content_int(0, "account_ip");
		cache_get_field_content(0, "character_password", PlayerData[playerid][Character_Password], connection, 129);

		// ----- Character Stats ------ //
        new Float:cpx = cache_get_field_content_float(0, "character_pos_x");
        new Float:cpy = cache_get_field_content_float(0, "character_pos_y");
        new Float:cpz = cache_get_field_content_float(0, "character_pos_z");
        new Float:cpa = cache_get_field_content_float(0, "character_pos_angle");

        PlayerData[playerid][Character_Registered] = cache_get_field_content_int(0, "character_registered");
       	PlayerData[playerid][Character_Age] = cache_get_field_content_int(0, "character_age");
	    cache_get_field_content(0, "character_sex", PlayerData[playerid][Character_Sex], connection, 129);
	    cache_get_field_content(0, "character_birthplace", PlayerData[playerid][Character_Birthplace], connection, 129);
	    PlayerData[playerid][Character_Skin] = cache_get_field_content_int(0, "character_skin");
	    
	    PlayerData[playerid][Character_Faction] = cache_get_field_content_int(0, "character_faction");
	    PlayerData[playerid][Character_Faction_Rank] = cache_get_field_content_int(0, "character_faction_rank");
	    PlayerData[playerid][Character_Faction_Join_Request] = cache_get_field_content_int(0, "character_faction_join_request");
	    
	    PlayerData[playerid][Character_Money] = cache_get_field_content_int(0, "character_money");
       	PlayerData[playerid][Character_Coins] = cache_get_field_content_int(0, "character_coins");
       	PlayerData[playerid][Character_VIP] = cache_get_field_content_int(0, "character_vip");
       	
        PlayerData[playerid][Character_Pos_X] = cpx;
        PlayerData[playerid][Character_Pos_Y] = cpy;
        PlayerData[playerid][Character_Pos_Z] = cpz;
        PlayerData[playerid][Character_Pos_Angle] = cpa;
        PlayerData[playerid][Character_Interior_ID] = cache_get_field_content_int(0, "character_interior_id");
       	PlayerData[playerid][Character_Virtual_World] = cache_get_field_content_int(0, "character_virtual_world");
        
		// ----- Admin Stats ------ //
	    PlayerData[playerid][Admin_Level] = cache_get_field_content_int(0, "admin_level");
	    PlayerData[playerid][Admin_Level_Exp] = cache_get_field_content_int(0, "admin_level_exp");
	    
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Golden Roleplay - Login", "This account has been registered before.\n\nPlease provide the password required:", "Login", "Quit");
    }
    else
    {
         ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Golden Roleplay - Registration", "This account has not been registered before on this server.\n\nPlease enter in a password that you will remember.", "Register", "Quit");
    }
    return 1;
}

forward SaveUserInformation(playerid);
public SaveUserInformation(playerid)
{
    GetPlayerName(playerid, PlayerData[playerid][Character_Name], MAX_PLAYER_NAME);
    
    GetPlayerPos(playerid, PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]);
	GetPlayerFacingAngle(playerid, PlayerData[playerid][Character_Pos_Angle]);
	
	PlayerData[playerid][Character_Interior_ID] = GetPlayerInterior(playerid);
	PlayerData[playerid][Character_Virtual_World] = GetPlayerVirtualWorld(playerid);

	new cquery[2000];
    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_registered` = '%i', `character_age` = '%i',`character_sex` = '%s',`character_birthplace` ='%s', `character_skin` ='%i', `character_pos_x` = '%f', `character_pos_y` = '%f', `character_pos_z` = '%f', `character_pos_angle` = '%f', `character_interior_id` = '%i', `character_virtual_world` = '%i'  WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Skin], PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z], PlayerData[playerid][Character_Pos_Angle], PlayerData[playerid][Character_Interior_ID], PlayerData[playerid][Character_Virtual_World], PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, cquery);
    
    new fquery[2000];
    mysql_format(connection, fquery, sizeof(fquery), "UPDATE `user_accounts` SET `character_faction` = '%i', `character_faction_rank` = '%i', `character_faction_join_request` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Faction], PlayerData[playerid][Character_Faction_Rank], PlayerData[playerid][Character_Faction_Join_Request], PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, fquery);
    
    new mquery[2000];
    mysql_format(connection, mquery, sizeof(mquery), "UPDATE `user_accounts` SET `character_money` = '%i', `character_coins` = '%i',`character_vip` = '%i' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Money], PlayerData[playerid][Character_Coins], PlayerData[playerid][Character_VIP], PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, mquery);

    new aquery[2000];
    mysql_format(connection, aquery, sizeof(aquery), "UPDATE `user_accounts` SET `admin_level` = '%i',`admin_level_exp` = '%i' WHERE `character_name` = '%e' LIMIT 1",PlayerData[playerid][Admin_Level], PlayerData[playerid][Admin_Level_Exp], PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, aquery);
	return 1;
}

forward RegistrationSpawn(playerid);
public RegistrationSpawn(playerid)
{
    SpawnPlayer(playerid);
    TextDrawShowForPlayer(playerid, Time);
    
	SetPlayerPos(playerid, -1877.8999,58.5820,1055.1891);
 	SetPlayerFacingAngle(playerid, 89.1804);
 	SetPlayerInterior(playerid, 14);
 	
 	PlayerData[playerid][Character_Money] =7500;
  	PlayerData[playerid][Character_Coins] +=20;

  	SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin]);
  	
  	SendClientMessage(playerid, COLOR_YELLOW, "Thank you for completing the registration of your character. For joining so early on in development, you");
  	SendClientMessage(playerid, COLOR_YELLOW, "have been given [20] coins and [$7500] in your wallet to get your character started!");
  	SendClientMessage(playerid, COLOR_YELLOW, "");
  	SendClientMessage(playerid, COLOR_YELLOW, "(Please take your time to go through our quick guides, that can be located at the front desk!)");


	return 1;
}

forward LoginSpawn(playerid);
public LoginSpawn(playerid)
{
    SpawnPlayer(playerid);
    TextDrawShowForPlayer(playerid, Time);
    
    if(PlayerData[playerid][Character_Registered] == 1)
    {
    	SetPlayerPos(playerid, PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z]);
		SetPlayerFacingAngle(playerid, PlayerData[playerid][Character_Pos_Angle]);
		
		SetPlayerInterior(playerid, PlayerData[playerid][Character_Interior_ID]);
		SetPlayerVirtualWorld(playerid, PlayerData[playerid][Character_Virtual_World]);
		
		SetPlayerSkin(playerid, PlayerData[playerid][Character_Skin]);
		
		SendClientMessage(playerid, COLOR_YELLOW, "Thank you for logging back into the server, you have been spawned at your last logout point!");
		
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

forward SERVER_ONESEC_TIMER();
public SERVER_ONESEC_TIMER()
{
	SetServerTimeForAll();

	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerLogged[i] == 1)
		{
		    if(PlayerData[i][Character_Registered] == 1)
		    {
		        if(IsPlayerInRangeOfPoint(i, 3.0, 1439.5317,-2281.4648,13.5469))
		        {
                    GameTextForPlayer(i, "/ASSISTANCE", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1439.3849,-2293.1267,13.5469))
		        {
                    GameTextForPlayer(i, "/HELP", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, 1418.1593,-2311.6946,13.9298))
		        {
                    GameTextForPlayer(i, "/RENTCAR", 5000, 5); // AIRPORT SPAWN
		        }
		        else if(IsPlayerInRangeOfPoint(i, 3.0, -1876.2999,50.1774,1055.1891))
		        {
                    GameTextForPlayer(i, "/GUIDE", 5000, 5); // AIRPORT SPAWN
		        }
		        for(new a = 1; a < MAX_DOORS; a++)
		        {
		            if(IsPlayerInRangeOfPoint(i, 3.0, DoorData[a][Door_Outside_X], DoorData[a][Door_Outside_Y], DoorData[a][Door_Outside_Z]))
		            {
		            	new tdstring[256];
					    format(tdstring, sizeof(tdstring), "Double Tap Enter_Key To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notfication_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
					if(IsPlayerInRangeOfPoint(i, 3.0, DoorData[a][Door_Inside_X], DoorData[a][Door_Inside_Y], DoorData[a][Door_Inside_Z]))
		            {
		            	new tdstring[256];
					    format(tdstring, sizeof(tdstring), "Double Tap Enter_Key To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notfication_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
		        for(new a = 1; a < MAX_HOUSES; a++)
		        {
                    if(HouseData[a][House_Outside_X] != 0 && HouseData[a][House_Sold] == 0)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[a][House_Outside_X], HouseData[a][House_Outside_Y], HouseData[a][House_Outside_Z]))
			            {
			            	new tdstring[256];
						    format(tdstring, sizeof(tdstring), "%s~n~~y~Cost: ~w~$%i~n~~y~Cost: ~w~%i Coins~n~~n~(Double tap ENTER_KEY to go inside!)~n~~n~~y~/buyproperty~w~ to buy this property!", HouseData[a][House_Address], HouseData[a][House_Price_Money], HouseData[a][House_Price_Coins]);
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notfication_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
					}
					if(HouseData[a][House_Outside_X] != 0 && HouseData[a][House_Sold] == 1)
                    {
			            if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[a][House_Outside_X], HouseData[a][House_Outside_Y], HouseData[a][House_Outside_Z]))
			            {
			            	new tdstring[256];
						    format(tdstring, sizeof(tdstring), "%s~n~~n~~y~Status:~w~ Owned~n~~y~Owner:~w~ %s~n~~n~(Double tap ENTER_KEY to go inside!)", HouseData[a][House_Address], HouseData[a][House_Owner]);
							PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring);
							PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

					        Notfication_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
						}
					}
					if(IsPlayerInRangeOfPoint(i, 3.0, HouseData[a][House_Inside_X], HouseData[a][House_Inside_Y], HouseData[a][House_Inside_Z]) && HouseData[a][House_Inside_VW] == GetPlayerVirtualWorld(i))
		            {
		            	new tdstring[256];
					    format(tdstring, sizeof(tdstring), "Double Tap Enter_Key To Use Door!");
						PlayerTextDrawSetString(i, PlayerText:Notification_Textdraw, tdstring);
						PlayerTextDrawShow(i, PlayerText:Notification_Textdraw);

				        Notfication_Timer[i] = SetTimerEx("OnTimerCancels", 4000, false, "i", i);
					}
		        }
			}
		}
	}
	return 1;
}

forward OnTimerCancels(playerid);
public OnTimerCancels(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		PlayerTextDrawHide(playerid, PlayerText:Notification_Textdraw);
		SERVER_ONESEC_TIMER();
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
	    new loaded = cache_get_field_content_int(0, "faction_id");

		FactionData[loaded][Faction_ID] = cache_get_field_content_int(0, "faction_id");
		cache_get_field_content(0, "faction_name", FactionData[loaded][Faction_Name], connection, 20);
		
		cache_get_field_content(0, "faction_rank_1", FactionData[loaded][Faction_Rank_1], connection, 20);
		cache_get_field_content(0, "faction_rank_2", FactionData[loaded][Faction_Rank_2], connection, 20);
		cache_get_field_content(0, "faction_rank_3", FactionData[loaded][Faction_Rank_3], connection, 20);
		cache_get_field_content(0, "faction_rank_4", FactionData[loaded][Faction_Rank_4], connection, 20);
		cache_get_field_content(0, "faction_rank_5", FactionData[loaded][Faction_Rank_5], connection, 20);
		cache_get_field_content(0, "faction_rank_6", FactionData[loaded][Faction_Rank_6], connection, 20);

		FactionData[loaded][Faction_Join_Requests] = cache_get_field_content_int(0, "faction_join_requests");
	}
	return 1;
}

forward GetNextFactionValue(playerid);
public GetNextFactionValue(playerid)
{
    if(cache_num_rows() > 0)
    {
        SQL_FACTION_NEXTID = cache_get_field_content_int(0, "faction_id");

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The next avaliable faction id is: %i and it hasn't been set up yet", SQL_FACTION_NEXTID);
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
	return 1;
}

forward LoadDoors_Results();
public LoadDoors_Results()
{
    new rows = cache_num_rows();
	
	if(rows)
	{
	    new loaded = cache_get_field_content_int(0, "door_id");
	    
		DoorData[loaded][Door_ID] = cache_get_field_content_int(0, "door_id");
		DoorData[loaded][Door_Faction] = cache_get_field_content_int(0, "door_faction");
		cache_get_field_content(0, "door_desc", DoorData[loaded][Door_Description], connection, 129);

        new Float:dex = cache_get_field_content_float(0, "door_outside_x");
        new Float:dey = cache_get_field_content_float(0, "door_outside_y");
        new Float:dez = cache_get_field_content_float(0, "door_outside_z");
        DoorData[loaded][Door_Outside_X] = dex;
        DoorData[loaded][Door_Outside_Y] = dey;
        DoorData[loaded][Door_Outside_Z] = dez;
        DoorData[loaded][Door_Outside_Interior] = cache_get_field_content_int(0, "door_outside_interior");
        DoorData[loaded][Door_Outside_VW] = cache_get_field_content_int(0, "door_outside_vw");

        new Float:dix = cache_get_field_content_float(0, "door_inside_x");
        new Float:diy = cache_get_field_content_float(0, "door_inside_y");
        new Float:diz = cache_get_field_content_float(0, "door_inside_z");
        DoorData[loaded][Door_Inside_X] = dix;
        DoorData[loaded][Door_Inside_Y] = diy;
        DoorData[loaded][Door_Inside_Z] = diz;
        DoorData[loaded][Door_Inside_Interior] = cache_get_field_content_int(0, "door_inside_interior");
        DoorData[loaded][Door_Inside_VW] = cache_get_field_content_int(0, "door_inside_vw");

        if(DoorData[loaded][Door_Outside_X] != 0)
      	{
     	    DoorData[loaded][Door_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,DoorData[loaded][Door_Outside_X], DoorData[loaded][Door_Outside_Y], DoorData[loaded][Door_Outside_Z]+0.5, -1);
		}
		if(DoorData[loaded][Door_Inside_X] != 0)
		{
		    DoorData[loaded][Door_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,DoorData[loaded][Door_Inside_X], DoorData[loaded][Door_Inside_Y], DoorData[loaded][Door_Inside_Z]+0.5, -1);
		}
	}
	return 1;
}

forward GetNextDoorValue(playerid);
public GetNextDoorValue(playerid)
{
    if(cache_num_rows() > 0)
    {
        SQL_DOOR_NEXTID = cache_get_field_content_int(0, "door_id");

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The next avaliable door id is: %i and it hasn't been set up yet", SQL_DOOR_NEXTID);
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
	return 1;
}

forward LoadHouses_Results();
public LoadHouses_Results()
{
    new rows = cache_num_rows();

	if(rows)
	{
	    new loaded = cache_get_field_content_int(0, "house_id");

		HouseData[loaded][House_ID] = cache_get_field_content_int(0, "house_id");
		HouseData[loaded][House_Price_Money] = cache_get_field_content_int(0, "house_price_money");
		HouseData[loaded][House_Price_Coins] = cache_get_field_content_int(0, "house_price_coins");
		HouseData[loaded][House_Sold] = cache_get_field_content_int(0, "house_sold");
		cache_get_field_content(0, "house_owner", HouseData[loaded][House_Owner], connection, 50);
		cache_get_field_content(0, "house_address", HouseData[loaded][House_Address], connection, 150);
		
		HouseData[loaded][House_Alarm] = cache_get_field_content_int(0, "house_alarm");
		HouseData[loaded][House_Lock] = cache_get_field_content_int(0, "house_lock");
		
		HouseData[loaded][House_Robbed] = cache_get_field_content_int(0, "house_robbed");
		HouseData[loaded][House_Robbed_Value] = cache_get_field_content_int(0, "house_robbed_value");
		
		new Float:hsx = cache_get_field_content_float(0, "house_spawn_x");
        new Float:hsy = cache_get_field_content_float(0, "house_spawn_y");
        new Float:hsz = cache_get_field_content_float(0, "house_spawn_z");
        HouseData[loaded][House_Spawn_X] = hsx;
        HouseData[loaded][House_Spawn_Y] = hsy;
        HouseData[loaded][House_Spawn_Z] = hsz;
        HouseData[loaded][House_Spawn_Interior] = cache_get_field_content_int(0, "house_spawn_interior");
        HouseData[loaded][House_Spawn_VW] = cache_get_field_content_int(0, "house_spawn_vw");

        new Float:hex = cache_get_field_content_float(0, "house_outside_x");
        new Float:hey = cache_get_field_content_float(0, "house_outside_y");
        new Float:hez = cache_get_field_content_float(0, "house_outside_z");
        HouseData[loaded][House_Outside_X] = hex;
        HouseData[loaded][House_Outside_Y] = hey;
        HouseData[loaded][House_Outside_Z] = hez;
        HouseData[loaded][House_Outside_Interior] = cache_get_field_content_int(0, "house_outside_interior");
        HouseData[loaded][House_Outside_VW] = cache_get_field_content_int(0, "house_outside_vw");

        new Float:hix = cache_get_field_content_float(0, "house_inside_x");
        new Float:hiy = cache_get_field_content_float(0, "house_inside_y");
        new Float:hiz = cache_get_field_content_float(0, "house_inside_z");
        HouseData[loaded][House_Inside_X] = hix;
        HouseData[loaded][House_Inside_Y] = hiy;
        HouseData[loaded][House_Inside_Z] = hiz;
        HouseData[loaded][House_Inside_Interior] = cache_get_field_content_int(0, "house_inside_interior");
        HouseData[loaded][House_Inside_VW] = cache_get_field_content_int(0, "house_inside_vw");
		
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
		    HouseData[loaded][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[loaded][House_Inside_X], HouseData[loaded][House_Inside_Y], HouseData[loaded][House_Inside_Z]+0.5, loaded);
		}
	}
	return 1;
}

forward GetNextHouseValue(playerid);
public GetNextHouseValue(playerid)
{
    if(cache_num_rows() > 0)
    {
        SQL_HOUSE_NEXTID = cache_get_field_content_int(0, "house_id");

        new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The next avaliable house id is: %i and it hasn't been set up yet", SQL_HOUSE_NEXTID);
		SendClientMessage(playerid, COLOR_ORANGE, dstring);

		SQL_HOUSE_NEXTID = 0;
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

forward DynamicDoorEntry(playerid);
public DynamicDoorEntry(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerNearDynamicDoor(playerid))
	    {
	        new ddoorid = PlayerAtDoorID[playerid];
	        if(IsPlayerInRangeOfPoint(playerid, 3.0, DoorData[ddoorid][Door_Outside_X], DoorData[ddoorid][Door_Outside_Y], DoorData[ddoorid][Door_Outside_Z]))
			{
				SetPlayerPos(playerid, DoorData[ddoorid][Door_Inside_X], DoorData[ddoorid][Door_Inside_Y], DoorData[ddoorid][Door_Inside_Z]);
				SetPlayerInterior(playerid, DoorData[ddoorid][Door_Inside_Interior]);
				SetPlayerVirtualWorld(playerid, DoorData[ddoorid][Door_Inside_VW]);
				
                PlayerAtDoorID[playerid] = 0;
			}
   			else if(IsPlayerInRangeOfPoint(playerid, 3.0, DoorData[ddoorid][Door_Inside_X], DoorData[ddoorid][Door_Inside_Y], DoorData[ddoorid][Door_Inside_Z]))
			{
				SetPlayerPos(playerid, DoorData[ddoorid][Door_Outside_X], DoorData[ddoorid][Door_Outside_Y], DoorData[ddoorid][Door_Outside_Z]);
				SetPlayerInterior(playerid, DoorData[ddoorid][Door_Outside_Interior]);
				SetPlayerVirtualWorld(playerid, DoorData[ddoorid][Door_Outside_VW]);
				
				PlayerAtDoorID[playerid] = 0;
   			}
	    }
	    
	    if(IsPlayerNearHouseDoor(playerid))
	    {
	    	new hdoorid = PlayerAtHouseID[playerid];
	        if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z]))
			{
				SetPlayerPos(playerid, HouseData[hdoorid][House_Inside_X], HouseData[hdoorid][House_Inside_Y], HouseData[hdoorid][House_Inside_Z]);
				SetPlayerInterior(playerid, HouseData[hdoorid][House_Inside_Interior]);
				SetPlayerVirtualWorld(playerid, HouseData[hdoorid][House_Inside_VW]);

                PlayerAtHouseID[playerid] = 0;
			}
   			else if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseData[hdoorid][House_Inside_X], HouseData[hdoorid][House_Inside_Y], HouseData[hdoorid][House_Inside_Z]))
			{
				SetPlayerPos(playerid, HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z]);
				SetPlayerInterior(playerid, HouseData[hdoorid][House_Outside_Interior]);
				SetPlayerVirtualWorld(playerid, HouseData[hdoorid][House_Outside_VW]);

				PlayerAtHouseID[playerid] = 0;
   			}
	    }
	}
	return 1;
}

forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
		{
        	if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
			{
        		GetPlayerPos(i, posx, posy, posz);
		        tempposx = (oldposx -posx);
		        tempposy = (oldposy -posy);
		        tempposz = (oldposz -posz);
       			if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
				{
        			SendClientMessage(i, col1, string);
				}
        		else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
				{
        			SendClientMessage(i, col2, string);
				}
 				else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
				{
        			SendClientMessage(i, col3, string);
				}
        		else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
				{
        			SendClientMessage(i, col4, string);
				}
 				else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
				{
        			SendClientMessage(i, col5, string);
				}
			}
        	else
			{
        		SendClientMessage(i, col1, string);
			}
		}
	}
 	return 1;
}

/* -------------- START OF STOCK FUNCTIONS FOR THE SCRIPT ---------------------- */
 
stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock SendAdminMessage(color, const string[], level)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerData[playerid][Admin_Level] >= 1)
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

/* -------------- START OF GAMEPLAY CONTROLS FOR USERS ---------------------- */

// GENERAL CHAT COMMANDS

CMD:me(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /me [ACTION]");
	
 	new string[128];
  	format(string, sizeof(string), "* %s %s", GetName(playerid), params);
   	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
   	
   	printf("CMD_ME: %s", string);
   	
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /do [ACTION]");
	
 	new string[128];
  	format(string, sizeof(string), "((* %s %s))", GetName(playerid), params);
   	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
   	
   	printf("CMD_DO: %s", string);
   	
	return 1;
}

CMD:whisper(playerid, params[]) return cmd_w(playerid,params);
CMD:w(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /w(hisper) [TEXT]");
    
	new message[128];
 	format(message, sizeof(message), "%s whispers: %s", GetName(playerid), params);
	ProxDetector(15.0, playerid, message, -1,-1,-1,-1,-1);
	
	printf("WhisperChat: %s", message);
	
	return 1;
}

CMD:shout(playerid, params[]) return cmd_s(playerid,params);
CMD:s(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /s(hout) [TEXT]");
    
	new message[128];
 	format(message, sizeof(message), "%s shouts: %s", GetName(playerid), params);
	ProxDetector(40.0, playerid, message, -1,-1,-1,-1,-1);
	
	printf("ShoutChat: %s", message);
	
	return 1;
}

CMD:ooc(playerid, params[]) return cmd_o(playerid,params);
CMD:o(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /o(oc) [TEXT]");

	new message[128];
 	format(message, sizeof(message), "([OOC] %s: %s )", GetName(playerid), params);
	ProxDetector(30.0, playerid, message, -1,-1,-1,-1,-1);

    printf("OOCChat: %s", message);
    
	return 1;
}

CMD:global(playerid, params[]) return cmd_g(playerid,params);
CMD:g(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /g(lobal) [TEXT]");
    if(GLOBALCHAT == 1) return SendPlayerErrorMessage(playerid, " You cannot use this feature at the moment. No admin has enabled global chat");

	new message[128];
 	format(message, sizeof(message), "([GLOBAL CHAT] %s: %s )", GetName(playerid), params);
	SendClientMessageToAll(COLOR_YELLOW, message);

	printf("GlobalChat: %s", message);
	
	return 1;
}

// GENERAL PLAYER COMMANDS

CMD:commands(playerid, params[]) return cmd_cmds(playerid, params);
CMD:cmds(playerid,params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerLogged[playerid])
	    {
			ShowPlayerDialog(playerid, DIALOG_COMMANDS_MAIN, DIALOG_STYLE_LIST, "Golden Roleplay - Commands Menu", "General Commands\nJob Commands\nFaction Commands\nHouse Commands\nBusiness Commands\nAdmin Commands", "Select", "Close");
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
	            ShowPlayerDialog(playerid, DIALOG_GUIDE_LIST, DIALOG_STYLE_LIST, "Golden Roleplay - Entry Guide", "Jobs\nFactions\nCommands\nVehicles\nHouses\nAdmins", "Select", "Close");
	        }
	        else return SendPlayerErrorMessage(playerid, " You are not near the /guide command help desk [Located within Airport Terminal]!");
	    }
	    else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	}
	return 1;
}

// FACTION COMMANDS

CMD:accept(playerid, params[])
{
	return 1;
}

CMD:reject(playerid, params[])
{
	return 1;
}

CMD:hire(playerid, params[])
{
	return 1;
}

CMD:fire(playerid, params[])
{
	return 1;
}

CMD:setrank(playerid, params[])
{
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
				
				format(dstring, sizeof(dstring), "((FOOC %s %s: %s ))", rankname, playername, params);
				SendFactionOOCMessage(factionid, COLOR_LIME, dstring);
			}
		}
	}
	return 1;
}

CMD:quitfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    if(PlayerData[playerid][Character_Faction] == 0) return SendPlayerErrorMessage(playerid, " You cannot quit a faction at this point in time. Reason: You are not apart of any faction!");
		{
		    new dstring[256];
			new factionid;
			
			factionid = PlayerData[playerid][Character_Faction];
			
		    PlayerData[playerid][Character_Faction] = 0;
		    PlayerData[playerid][Character_Faction_Rank] = 0;
		    
		    format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just left the %s faction. We are sorry to see you leave!", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
		    
		    format(dstring, sizeof(dstring), "[FACTION ALERT:]{FFFFFF} %s has just left the faction!", GetName(playerid));
			SendFactionOOCMessage(factionid, COLOR_RED, dstring);
		}
	}
	return 1;
}

CMD:joinfaction(playerid, params[])
{
	if(PlayerData[playerid][Character_Registered] != 1) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new factionid;
	    new dstring[256];
	    
	    if(PlayerData[playerid][Character_Faction] > 0) return SendPlayerErrorMessage(playerid, " You are already apart of a faction, you cannot rejoin/join any new factions at this time!");

		if(IsPlayerInRangeOfPoint(playerid, 3.0, 0, 0, 0)) // LSPD JOIN LOCATION
		{
		    factionid = 1;
		    
		    PlayerData[playerid][Character_Faction_Join_Request] = 1;
		    
		    format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just applied to join the %s. Please wait to be accepted into the faction. [WARNING: This process can take days!]", FactionData[factionid][Faction_Name]);
			SendClientMessage(playerid, COLOR_YELLOW, dstring);
		    
		    FactionData[factionid][Faction_Join_Requests] += 1;
		    
		    new fquery[2000];
		    mysql_format(connection, fquery, sizeof(fquery), "UPDATE `faction_information` SET `faction_join_requests` = '%i' WHERE `faction_id` = '%i' LIMIT 1", FactionData[factionid][Faction_Join_Requests], factionid);
		    mysql_tquery(connection, fquery);
		    
		    for(new t = 0; t <= MAX_PLAYERS; t++)
		    {
		        if(PlayerData[t][Character_Faction] == 1 && PlayerData[t][Character_Faction_Rank] == 6)
		        {
			    	format(dstring, sizeof(dstring), "[FACTION ALERT:]{FFFFFF} %s has just applied [in-game] to join the faction. /accept or /reject the offer to join!", PlayerData[t][Character_Name]);
					SendClientMessage(t, COLOR_RED, dstring);
				}
			}
		}
		else return SendPlayerErrorMessage(playerid, " You are not near any faction pickup that allows this command!");
	}
	return 1;
}

// PROPERTY COMMANDS

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

      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '', `house_sold` = '0' WHERE `house_id` = '%i' LIMIT 1", hdoorid);
			mysql_tquery(connection, equery);

			HouseData[hdoorid][House_Owner] = namestring;
			HouseData[hdoorid][House_Sold] = 0;
			PlayerData[playerid][Character_Money] += HouseData[hdoorid][House_Price_Money];

			format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just sold your house %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Money]);
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
     	new hdoorid, response;
     	
		namestring = GetName(playerid);
		
		if(sscanf(params, "i", response))
		{
		    SendPlayerServerMessage(playerid, " /buyproperty [option]");
		    SendPlayerServerMessage(playerid, " Options: [1 - Money | 2 - Coins]");
		}
		else
  		{
  		    if(!IsPlayerNearHouseDoor(playerid) || PlayerAtHouseID[playerid] == 0) return SendPlayerErrorMessage(playerid, " You are not standing near a house front door!");

			hdoorid = PlayerAtHouseID[playerid];
  		    if(hdoorid != 0 && HouseData[hdoorid][House_Owner] != PlayerData[playerid][Character_Name] && HouseData[hdoorid][House_Sold] == 1)
			{
			    SendPlayerErrorMessage(playerid, " You cannot purchase a property that someone else already owns! You can view all ownerships of properties, down at the city council!");
			}
			if(response == 1)
			{
			    if(PlayerData[playerid][Character_Money] < HouseData[hdoorid][House_Price_Money]) return SendPlayerErrorMessage(playerid, " You do not have enough money in hand to purchase this property!");

				DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
			    HouseData[hdoorid][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z], -1);

	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '%e', `house_sold` = '1' WHERE `house_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], hdoorid);
				mysql_tquery(connection, equery);

				HouseData[hdoorid][House_Owner] = namestring;
				HouseData[hdoorid][House_Sold] = 1;
				PlayerData[playerid][Character_Money] -= HouseData[hdoorid][House_Price_Money];

				format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just purchased property %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Money]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				PlayerAtHouseID[playerid] = 0;
			}
			else if(response == 2)
			{
			    if(PlayerData[playerid][Character_Coins] < HouseData[hdoorid][House_Price_Coins]) return SendPlayerErrorMessage(playerid, " You do not have enough coins on your account to purchase this property!");

				DestroyDynamicPickup(HouseData[hdoorid][House_Pickup_ID_Outside]);
			    HouseData[hdoorid][House_Pickup_ID_Outside] = CreateDynamicPickup(1272, 1,HouseData[hdoorid][House_Outside_X], HouseData[hdoorid][House_Outside_Y], HouseData[hdoorid][House_Outside_Z], -1);

	      		mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_owner` = '%e', `house_sold` = '1' WHERE `house_id` = '%i' LIMIT 1", PlayerData[playerid][Character_Name], hdoorid);
				mysql_tquery(connection, equery);

				HouseData[hdoorid][House_Owner] = namestring;
				HouseData[hdoorid][House_Sold] = 1;
				PlayerData[playerid][Character_Coins] -= HouseData[hdoorid][House_Price_Coins];

				format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just purchased property %s for $%d", HouseData[hdoorid][House_Address], HouseData[hdoorid][House_Price_Coins]);
				SendClientMessage(playerid, COLOR_YELLOW, dstring);
				
				PlayerAtHouseID[playerid] = 0;
			}
		}
	}
	return 1;
}

/* -------------- START OF ADMINS COMMANDS ---------------------- */

// LEVEL 1 ADMIN COMMANDS

// /spectate /kick /ajail

CMD:adminchat(playerid, params[]) return cmd_a(playerid, params);
CMD:a(playerid, params[])
{
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
			format(dstring, sizeof(dstring), "(([Admin: %s]: %s))", GetName(playerid), amessage);
			SendClientMessage(playerid, COLOR_RED, dstring);
			
			printf("AdminChat: %s", dstring);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:gotols(playerid,params[])
{
    if(PlayerData[playerid][Admin_Level] >= 1)
    {
	   	SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
	   	SetPlayerInterior(playerid, 0);
	    SetPlayerVirtualWorld(playerid, 0);
		    
	   	new dstring[256];
		format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have just teleported to Los Santos Central Map");
		SendClientMessage(playerid, COLOR_ORANGE, dstring);
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
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have succesfully teleported to location: %f, %f, %f, Interior ID: %i and VW: %i", x, y, z, intid, vw);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

// LEVEL 2 ADMIN COMMANDS

// /getplayer /getcar /gotoplayer /gotocar /tempban
CMD:unmute(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new targetid;
		if(sscanf(params, "i", targetid))
		{
		    SendPlayerServerMessage(playerid, " /unmute [targetid]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
			    IsPlayerMuted[targetid] = 0;

				new dstring[156];
				format(dstring, sizeof(dstring), "[SERVER]:%s has been unmuted by a server admin", GetName(targetid));
				SendClientMessageToAll(COLOR_RED, dstring);

				printf("CMD_unmute: %s", dstring);
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

CMD:mute(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] >= 2)
	{
	    new amessage[156], targetid;
		if(sscanf(params, "is[156]", targetid, amessage))
		{
		    SendPlayerServerMessage(playerid, " /mute [targetid] [reason]");
		}
		else
		{
		    if(IsPlayerLogged[targetid] == 0) return SendPlayerErrorMessage(playerid, " You need to provide an online player id!");
		    else
		    {
			    IsPlayerMuted[targetid] = 1;

				new dstring[256];
				format(dstring, sizeof(dstring), "[SERVER]:%s has been temp muted by a server admin. Reason: %s", GetName(targetid), amessage);
				SendClientMessageToAll(COLOR_RED, dstring);

				format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} If you feel that this temp mute is not justified, please report this action on our forum!");
				SendClientMessage(targetid, COLOR_YELLOW, dstring);

				printf("CMD_mute: %s", dstring);
			}
		}
	}
	else return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	return 1;
}

// LEVEL 3 ADMIN COMMANDS

// /ban /killplayer /startevent /stopevent /editevent /randomwinner

// LEVEL 4 ADMIN COMMANDS

// /givemoney /giveweapon /removeweapon /weaponban /factionban

// LEVEL 5 ADMIN COMMANDS

// /setstats /gotodoor /gotohouse /createplayervehicle /vehcreate /vehfaction /vehdelete /vehowner /vehnext /vehinfo
CMD:fnext(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] >= 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `faction_information` WHERE `faction_name` = '' LIMIT 1");
		mysql_tquery(connection, query, "GetNextFactionValue");
	}
	return 1;
}

CMD:finfo(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] >= 5) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid;

		if(sscanf(params, "i", factionid))
		{
			SendPlayerServerMessage(playerid, " /finfo [factionid]");
		}
		else
		{
			new dstring[256];
			
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The below information has been pulled directly from the database!");
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

CMD:fedit(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] > 4) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new factionid, option;
		new acquery[2000], value[20], dstring[256];

		if(sscanf(params, "iis[20]", factionid))
		{
			SendPlayerServerMessage(playerid, " /fedit [factionid] [option] [value]");
			SendPlayerServerMessage(playerid, " OPTIONS: 1 to 6 - Rank Name | 7 - Faction Name");
			SendPlayerServerMessage(playerid, " RANK HELP: 1 = Lowest & 6 = Highest Rank");
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
    				
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 1 name to be %s", factionid, FactionData[factionid][Faction_Rank_1]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 2:
			    {
			        FactionData[factionid][Faction_Rank_2] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_2` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 2 name to be %s", factionid, FactionData[factionid][Faction_Rank_1]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 3:
			    {
			        FactionData[factionid][Faction_Rank_3] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_3` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 3 name to be %s", factionid, FactionData[factionid][Faction_Rank_3]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 4:
			    {
			        FactionData[factionid][Faction_Rank_4] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_4` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 4 name to be %s", factionid, FactionData[factionid][Faction_Rank_4]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 5:
			    {
			        FactionData[factionid][Faction_Rank_5] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_5` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 5 name to be %s", factionid, FactionData[factionid][Faction_Rank_5]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 6:
			    {
			        FactionData[factionid][Faction_Rank_6] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_rank_6` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Factions(ID: %i, Name: %s), Rank 6 name to be %s", factionid, FactionData[factionid][Faction_Rank_5]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			    case 7:
			    {
			        FactionData[factionid][Faction_Name] = value;

	        		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_name` = '%s' WHERE `faction_id` = '%i' LIMIT 1", value, factionid);
    				mysql_tquery(connection, acquery);

					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated Faction(ID: %i) name to be %s", factionid, FactionData[factionid][Faction_Name]);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
			    }
			}
		}
	}
	return 1;
}

CMD:fdelete(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] > 4) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
  			
  			
       		mysql_format(connection, acquery, sizeof(acquery), "UPDATE `faction_information` SET `faction_name` = '', `faction_rank_1` = '', `faction_rank_2` = '', `faction_rank_3` = '', `faction_rank_4` = '', `faction_rank_5` = '', `faction_rank_6` = '', `faction_join_requests` = '0' WHERE `faction_id` = '%i' LIMIT 1", factionid);
			mysql_tquery(connection, acquery);

			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have delete Faction(ID: %i) from the system!", factionid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

// LEVEL 6 ADMIN COMMANDS

///givecoins
CMD:jetpack(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	    SendPlayerServerMessage(playerid, "You have just spawned yourself a jetpack using an admin command");
	}
	return 1;
}

CMD:globalchat(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `door_information` WHERE `door_outside_x` = '0' LIMIT 1");
		mysql_tquery(connection, query, "GetNextDoorValue");
	}
	return 1;
}

CMD:ddinfo(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid;

		if(sscanf(params, "i", doorid))
		{
			SendPlayerServerMessage(playerid, " /ddinfo [doorid]");
		}
		else
		{
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID that you have searched for: %i, has a name of: %s", doorid, DoorData[doorid][Door_Description]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddname(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
   			mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_desc` = '%s' WHERE `door_id` = '%i' LIMIT 1", value1, doorid);
   			mysql_tquery(connection, query);

			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID: %i, has had a name changed to: %s", doorid, DoorData[doorid][Door_Description]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddfaction(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID: %i, has had a faction status changed to: %i", doorid, DoorData[doorid][Door_Faction]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:ddedit(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new doorid, value1;
		new Float:x, Float:y, Float:z;
		new intid, vwid;
		GetPlayerPos(playerid, x, y, z);
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
                    
                    DoorData[doorid][Door_Outside_Interior] = intid;
                    DoorData[doorid][Door_Outside_VW] = vwid;
                    
                    DoorData[doorid][Door_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,DoorData[doorid][Door_Outside_X], DoorData[doorid][Door_Outside_Y], DoorData[doorid][Door_Outside_Z]+0.5, -1);
                    
                    printf("%i", DoorData[doorid][Door_Pickup_ID_Outside]);
                    
                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_outside_x` = '%f', `door_outside_y` = '%f', `door_outside_z` = '%f', `door_outside_interior` = '%i', `door_outside_vw` ='%i' WHERE `door_id` = '%i' LIMIT 1", DoorData[doorid][Door_Outside_X], DoorData[doorid][Door_Outside_Y], DoorData[doorid][Door_Outside_Z], DoorData[doorid][Door_Outside_Interior], DoorData[doorid][Door_Outside_VW], doorid);
		    		mysql_tquery(connection, query);
		    		
		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID: %i, has had the exterior location changed to your spot", doorid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 2:
		        {
		            DestroyDynamicPickup(DoorData[doorid][Door_Pickup_ID_Inside]);
		            
                    DoorData[doorid][Door_Inside_X] = x;
                    DoorData[doorid][Door_Inside_Y] = y;
                    DoorData[doorid][Door_Inside_Z] = z;

                    DoorData[doorid][Door_Inside_Interior] = intid;
                    DoorData[doorid][Door_Inside_VW] = vwid;
                    
                    DoorData[doorid][Door_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,DoorData[doorid][Door_Inside_X], DoorData[doorid][Door_Inside_Y], DoorData[doorid][Door_Inside_Z]+0.5, -1);
                    
                    printf("%i", DoorData[doorid][Door_Pickup_ID_Inside]);
                    
                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `door_information` SET `door_inside_x` = '%f', `door_inside_y` = '%f', `door_inside_z` = '%f', `door_inside_interior` = '%i', `door_inside_vw` ='%i' WHERE `door_id` = '%i' LIMIT 1", DoorData[doorid][Door_Inside_X], DoorData[doorid][Door_Inside_Y], DoorData[doorid][Door_Inside_Z], DoorData[doorid][Door_Inside_Interior], DoorData[doorid][Door_Inside_VW], doorid);
		    		mysql_tquery(connection, query);
		    		
		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID: %i, has had the interior location changed to your spot", doorid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
			}
		}
	}
	return 1;
}

CMD:dddelete(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
	        DoorData[ddoorid][Door_Outside_Interior] = 0;
	        DoorData[ddoorid][Door_Outside_VW] = 0;
	        DoorData[ddoorid][Door_Inside_X] = 0;
	        DoorData[ddoorid][Door_Inside_Y] = 0;
	        DoorData[ddoorid][Door_Inside_Z] = 0;
	        DoorData[ddoorid][Door_Inside_Interior] = 0;
	        DoorData[ddoorid][Door_Inside_VW] = 0;

			new equery[2000];
	        mysql_format(connection, equery, sizeof(equery), "UPDATE `door_information` SET `door_outside_x` = '0', `door_outside_y` = '0', `door_outside_z` = '0', `door_outside_interior` = '0', `door_outside_vw` ='0', `door_inside_x` = '0', `door_inside_y` = '0', `door_inside_z` = '0', `door_inside_interior` = '0', `door_inside_vw` ='0', `door_faction` = '0', `door_desc` = '' WHERE `door_id` = '%i' LIMIT 1", ddoorid);
	  		mysql_tquery(connection, equery);

    		new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The Door ID: %i has been deleted", ddoorid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
			
			PlayerAtDoorID[playerid] = 0;
		}
	}
	return 1;
}

CMD:hnext(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
	    new query[128];
	    mysql_format(connection, query, sizeof(query), "SELECT * FROM `house_information` WHERE `house_outside_x` = '0' LIMIT 1");
		mysql_tquery(connection, query, "GetNextHouseValue");
	}
	return 1;
}

CMD:hinfo(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid;

		if(sscanf(params, "i", houseid))
		{
			SendPlayerServerMessage(playerid, " /hinfo [houseid]");
		}
		else
		{
			new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The House ID that you have searched for: %i, has a owner called: %s", houseid, HouseData[houseid][House_Owner]);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);
		}
	}
	return 1;
}

CMD:hedit(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
	{
		new houseid, value1;
		new Float:x, Float:y, Float:z;
		new intid, vwid;
		GetPlayerPos(playerid, x, y, z);
		intid = GetPlayerInterior(playerid);
		vwid = GetPlayerVirtualWorld(playerid);

		if(sscanf(params, "ii", houseid, value1))
		{
			SendPlayerServerMessage(playerid, " /hedit [houseid] [option]");
			SendPlayerServerMessage(playerid, " Options: [Exterior (1) | Interior (2)]");
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

                    HouseData[houseid][House_Outside_Interior] = intid;
                    HouseData[houseid][House_Outside_VW] = vwid;

                    if(HouseData[houseid][House_Outside_X] != 0 && HouseData[houseid][House_Sold] == 0)
			      	{
			     	    HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(1273, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], -1);
					}
			        if(HouseData[houseid][House_Outside_X] != 0 && HouseData[houseid][House_Sold] == 1)
			      	{
			     	    HouseData[houseid][House_Pickup_ID_Outside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z]+0.5, -1);
					}

                    printf("%i", HouseData[houseid][House_Pickup_ID_Outside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_outside_x` = '%f', `house_outside_y` = '%f', `house_outside_z` = '%f', `house_outside_interior` = '%i', `house_outside_vw` ='%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Outside_X], HouseData[houseid][House_Outside_Y], HouseData[houseid][House_Outside_Z], HouseData[houseid][House_Outside_Interior], HouseData[houseid][House_Outside_VW], houseid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The House ID: %i, has had the exterior location changed to your spot", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
				case 2:
		        {
		            DestroyDynamicPickup(HouseData[houseid][House_Pickup_ID_Inside]);

                    HouseData[houseid][House_Inside_X] = x;
                    HouseData[houseid][House_Inside_Y] = y;
                    HouseData[houseid][House_Inside_Z] = z;

                    HouseData[houseid][House_Inside_Interior] = intid;
                    HouseData[houseid][House_Inside_VW] = houseid;

                    HouseData[houseid][House_Pickup_ID_Inside] = CreateDynamicPickup(19198, 1,HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z]+0.5, houseid);

                    printf("%i", HouseData[houseid][House_Pickup_ID_Inside]);

                    new query[2000];
			        mysql_format(connection, query, sizeof(query), "UPDATE `house_information` SET `house_inside_x` = '%f', `house_inside_y` = '%f', `house_inside_z` = '%f', `house_inside_interior` = '%i', `house_inside_vw` ='%i' WHERE `house_id` = '%i' LIMIT 1", HouseData[houseid][House_Inside_X], HouseData[houseid][House_Inside_Y], HouseData[houseid][House_Inside_Z], HouseData[houseid][House_Inside_Interior], HouseData[houseid][House_Inside_VW], houseid);
		    		mysql_tquery(connection, query);

		    		new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The House ID: %i, has had the interior location changed to your spot", houseid);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
				}
			}
		}
	}
	return 1;
}

CMD:hdelete(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
	        HouseData[hdoorid][House_Outside_Interior] = 0;
	        HouseData[hdoorid][House_Outside_VW] = 0;
	        HouseData[hdoorid][House_Inside_X] = 0;
	        HouseData[hdoorid][House_Inside_Y] = 0;
	        HouseData[hdoorid][House_Inside_Z] = 0;
	        HouseData[hdoorid][House_Inside_Interior] = 0;
	        HouseData[hdoorid][House_Inside_VW] = 0;

			new equery[2000];
	        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_price_money` = '0', `house_price_coins` = '0', `house_owner` = '%s',`house_address` = '%s', `house_sold` = '0', `house_alarm` = '0', `house_lock` = '0', `house_robbed` = '0', `house_robbed_value` = '0', `house_spawn_x` = '0', `house_spawn_y` = '0', `house_spawn_z` = '0', `house_spawn_interior` = '0', `house_spawn_vw` = '0', `house_outside_x` = '0', `house_outside_y` = '0', `house_outside_z` = '0', `house_outside_interior` = '0', `house_outside_vw` = '0', `house_inside_x` = '0', `house_inside_y` = '0', `house_inside_z` = '0', `house_inside_interior` = '0', `house_inside_vw` = '0' WHERE `house_id` = '%i' LIMIT 1", dvalue, avalue, hdoorid);
	  		mysql_tquery(connection, equery);

    		new dstring[256];
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} The House ID: %i has been deleted", hdoorid);
			SendClientMessage(playerid, COLOR_ORANGE, dstring);

			PlayerAtHouseID[playerid] = 0;
		}
	}
	return 1;
}

CMD:hsetaddress(playerid, params[])
{
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
			format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have updated House ID: %i address to be %s", houseid, HouseData[houseid][House_Owner]);
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
    if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} House ID: %i has been updated with a new coin cost of: %i", houseid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		        case 2:
		        {
		            HouseData[houseid][House_Price_Money] = value;

		            new equery[2000];
			        mysql_format(connection, equery, sizeof(equery), "UPDATE `house_information` SET `house_price_money` = '%i' WHERE `house_id` = '%i' LIMIT 1", value, houseid);
			  		mysql_tquery(connection, equery);

		            new dstring[256];
					format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} House ID: %i has been updated with a new money cost of: %i", houseid, value);
					SendClientMessage(playerid, COLOR_ORANGE, dstring);
		        }
		    }
		}
	}
	return 1;
}

CMD:hsetowner(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
				format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have just set player(ID: %i, Name: %s) owner of property id: %i", targetid, PlayerData[targetid][Character_Name], houseid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} You have just been given ownership of property %s", HouseData[houseid][House_Address]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

CMD:hremoveowner(playerid, params[])
{
	if(PlayerData[playerid][Admin_Level] != 6) return SendPlayerErrorMessage(playerid, " You do not have access to this feature!");
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
				format(dstring, sizeof(dstring), "[SERVER:]{FFFFFF} You have just removed player(ID: %i, Name: %s) from house id: %i", targetid, PlayerData[targetid][Character_Name], houseid);
				SendClientMessage(playerid, COLOR_ORANGE, dstring);

				format(dstring, sizeof(dstring), "[UPDATE:]{FFFFFF} An admin has just removed you from property: %s", HouseData[houseid][House_Address]);
				SendClientMessage(targetid, COLOR_YELLOW, dstring);
			}
		}
	}
	return 1;
}

