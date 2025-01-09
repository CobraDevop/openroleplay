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

#define 	SERVER_NAME 		"Open Rolepaly - New Release Open.mp"
#define 	SERVER_VERSION 		"0.0.1b"
#define 	SERVER_MAPNAME  	"Los Santos"

#define 	SERVER_INT_WEATHER 	"1"
#define 	SERVER_INT_TIME 	"12"

/* ------ SQL CONNECTION INFORMATION ------- */

#define 	SQL_SERVER 			"localhost"
#define 	SQL_USER 			"root"
#define 	SQL_PASSWORD 		""
#define 	SQL_DB 				"openroleplay"

new connection = -1;

/* ------ GENERAL INFORMATION ------- */

// COLOR DEFINES
#define 	COLOR_RED			0xFF0000AA
#define 	COLOR_BLUE			0x0000BBAA
#define 	COLOR_YELLOW		0xFFFF00AA
#define 	COLOR_TOMATO		0xFF6347AA
#define 	COLOR_WHITE 		0xFFFFFFAA
#define 	COLOR_ORANGE		0xFF9900AA
#define 	COLOR_GREY 			0xAFAFAFAA
#define 	COLOR_GREEN 		0x33AA33AA
#define 	COLOR_PINK 			0xFFC0CBAA

// DIALOG DEFINES
#define DIALOG_LOGIN 			1
#define DIALOG_REGISTER 		2
#define DIALOG_REGISTER_EMAIL   3
#define DIALOG_REGISTER_AGE     4
#define DIALOG_REGISTER_SEX     5
#define DIALOG_REGISTER_BP      6
#define DIALOG_REGISTER_END     7
 
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

new PlayerIsLogged[MAX_PLAYERS];

/*-----------------------------------------------------------------------------
						INITIAL GAMEMODE CODE STARTS HERE
-----------------------------------------------------------------------------*/
main(){}
 
public OnGameModeInit()
{
    SetGameModeText(SERVER_VERSION);
	
	mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML);
    connection = mysql_connect("localhost", "root", "openroleplay", "");
    
	ShowPlayerMarkers(0);
	ShowNameTags(1);
	SetNameTagDrawDistance(6.0);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
    ManualVehicleEngineAndLights();
    
    LoadAllMaps();
    
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
 
    PlayerIsLogged[playerid] = 0;

	RemoveBuildings(playerid);
    
    return 1;
}
 
public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerIsLogged[playerid] == 0) return 0;
    
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
    if(PlayerIsLogged[killerid] == 0) return 0;
    if(PlayerIsLogged[playerid] == 0) return 0;
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
    return 1;
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
		        	PlayerIsLogged[playerid] = 1;

				    TogglePlayerSpectating(playerid, 0);
				    
				    ClearMessages(playerid);

					LoginSpawn(playerid);
				}
	        }
	        else
	        {
	            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Open Roleplay - Login", "This account has been registered before and\nyou have not provided the correct password.\n\nPlease provide the password required:", "Login", "Quit");
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

forward OnAccountCreation(playerid);
public OnAccountCreation(playerid)
{
    PlayerData[playerid][Account_ID] = cache_insert_id();
    PlayerIsLogged[playerid] = 1;
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
	    
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Open Roleplay - Login", "This account has been registered before.\n\nPlease provide the password required:", "Login", "Quit");
    }
    else
    {
         ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Open Roleplay - Registration", "This account has not been registered before on this server.\n\nPlease enter in a password that you will remember.", "Register", "Quit");
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
