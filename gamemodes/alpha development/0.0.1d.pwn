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
#define 	SERVER_VERSION 		"0.0.1d"
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

#define 	MAX_DOORS       		200
 
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

new IsPlayerLogged[MAX_PLAYERS];
new PlayerAtDoorID[MAX_PLAYERS];

// TEXTDRAW REFERNCES

new Text:Time;

/*-----------------------------------------------------------------------------
						INITIAL GAMEMODE CODE STARTS HERE
-----------------------------------------------------------------------------*/
main(){}
 
public OnGameModeInit()
{
	
    SetGameModeText(SERVER_VERSION);
	
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
    new query[128];
    GetPlayerName(playerid, PlayerData[playerid][Character_Name], MAX_PLAYER_NAME);
    
    mysql_format(connection, query, sizeof(query), "SELECT * FROM `user_accounts` WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, query, "OnAccountCheck", "i", playerid);
 
    IsPlayerLogged[playerid] = 0;
    PlayerAtDoorID[playerid] = 0;

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
	                ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email", "(YOU HAVEN'T COMPLETED YOUR CHARACTER REGISTRATION YET, PLEASE START FROM THE BEGINING)\n\nPlease enter a valid email address\n\nThis may be used for UCP features in the future:", "Next", "Quit");
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
			
	        ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email", "Please enter a valid email address\n\nThis may be used for UCP features in the future:", "Next", "Quit");
	    }
	    case DIALOG_REGISTER_EMAIL:
	    {
	   		if(!response) return Kick(playerid);
	        if(!strlen(inputtext)) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email [ERROR]", "(You did not enter any email address)\n\nPlease enter a valid email address\n\nThis may be used for UCP features in the future:", "Next", "Quit");
			if(strfind(inputtext, "@") == -1) return  ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Account Creation - Email [ERROR]", "(You did not enter any email address)\n\nPlease enter a valid email address\n\nThis may be used for UCP features in the future:", "Next", "Quit");

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
			        case 0: { stext = "Male"; }
			        case 1: { stext = "Female"; }
			        case 2: { stext = "Non-Binary"; }
			        case 3: { stext = "Transgender"; }
			        case 4: { stext = "Ghost"; }
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
	        mysql_format(connection, acquery, sizeof(acquery), "UPDATE `user_accounts` SET `account_email` = '%s', `character_registered` = '%i', `character_age` = '%i',`character_sex` = '%s',`character_birthplace` ='%s' WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Account_Email], PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Name]);
    		mysql_tquery(connection, acquery);

			TogglePlayerSpectating(playerid, 0);
	        
	        ClearMessages(playerid);
	        
	        RegistrationSpawn(playerid);
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
    mysql_format(connection, cquery, sizeof(cquery), "UPDATE `user_accounts` SET `character_registered` = '%i', `character_age` = '%i',`character_sex` = '%s',`character_birthplace` ='%s', `character_pos_x` = '%f', `character_pos_y` = '%f', `character_pos_z` = '%f', `character_pos_angle` = '%f', `character_interior_id` = '%i', `character_virtual_world` = '%i'  WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Registered], PlayerData[playerid][Character_Age], PlayerData[playerid][Character_Sex], PlayerData[playerid][Character_Birthplace], PlayerData[playerid][Character_Pos_X], PlayerData[playerid][Character_Pos_Y], PlayerData[playerid][Character_Pos_Z], PlayerData[playerid][Character_Pos_Angle], PlayerData[playerid][Character_Interior_ID], PlayerData[playerid][Character_Virtual_World], PlayerData[playerid][Character_Name]);
    mysql_tquery(connection, cquery);
    
    new mquery[2000];
    mysql_format(connection, mquery, sizeof(mquery), "UPDATE `user_accounts` SET `character_money` = '%i', `character_coins` = '%i',`character_vip` = '%i'  WHERE `character_name` = '%e' LIMIT 1", PlayerData[playerid][Character_Money], PlayerData[playerid][Character_Coins], PlayerData[playerid][Character_VIP], PlayerData[playerid][Character_Name]);
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
			}
		}
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

        new Float:dix = cache_get_field_content_float(0, "door_inside_x");
        new Float:diy = cache_get_field_content_float(0, "door_inside_y");
        new Float:diz = cache_get_field_content_float(0, "door_inside_z");
        DoorData[loaded][Door_Inside_X] = dix;
        DoorData[loaded][Door_Inside_Y] = diy;
        DoorData[loaded][Door_Inside_Z] = diz;

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

forward DynamicDoorEntry(playerid);
public DynamicDoorEntry(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new ddoorid = PlayerAtDoorID[playerid];
	    if(IsPlayerNearDynamicDoor(playerid))
	    {
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

CMD:me(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /me [ACTION]");
 	new string[128];
  	format(string, sizeof(string), "* %s %s", GetName(playerid), params);
   	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params)) return SendPlayerServerMessage(playerid, " /do [ACTION]");
 	new string[128];
  	format(string, sizeof(string), "((* %s %s))", GetName(playerid), params);
   	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:whisper(playerid, params[]) return cmd_w(playerid,params);
CMD:w(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /w(hisper) [TEXT]");
	new message[128];
 	format(message, sizeof(message), "%s whispers: %s", GetName(playerid), params);
	ProxDetector(15.0, playerid, message, -1,-1,-1,-1,-1);
	return 1;
}

CMD:shout(playerid, params[]) return cmd_s(playerid,params);
CMD:s(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /s(hout) [TEXT]");
	new message[128];
 	format(message, sizeof(message), "%s shouts: %s", GetName(playerid), params);
	ProxDetector(40.0, playerid, message, -1,-1,-1,-1,-1);
	return 1;
}

CMD:ooc(playerid, params[]) return cmd_o(playerid,params);
CMD:o(playerid, params[])
{
    if(isnull(params)) return SendPlayerServerMessage(playerid, " /o(oc) [TEXT]");
	new message[128];
 	format(message, sizeof(message), "([OOC] %s: %s )", GetName(playerid), params);
	ProxDetector(30.0, playerid, message, -1,-1,-1,-1,-1);
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
	return 1;
}

/* -------------- START OF ADMINS COMMANDS ---------------------- */

// LEVEL 6 ADMIN COMMANDS

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
		            DestroyPickup(DoorData[doorid][Door_Pickup_ID_Outside]);
		            
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
		            DestroyPickup(DoorData[doorid][Door_Pickup_ID_Inside]);
		            
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

