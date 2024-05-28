// - - - - - - - - - - - - - - |
// *
// Boombox Sistemi 
// Script: Rever - Batu
// *
// - - - - - - - - - - - - - - |

#define     SSCANF_NO_NICE_FEATURES

#include    <a_samp>
#include    <sscanf2>
#include    <zcmd>

#if defined FILTERSCRIPT


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Rever - Boombox Sistemi v1.0");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Rever - Boombox Sistemi v1.0");
	print("----------------------------------\n");
}

#endif

#define     MESAJ_RENK      (0x00ff6aAA)

#define     MAX_BOOMBOX     (50) // 50 Adet (Boombox)

#define     DIALOG_BOOMBOX_SARKI        (15) // [dilaog_name: DIALOG_BOOMBOX_SARKI | dialog id: 15]

enum kutuVeri {

    boomboxID,
    boomboxName[32],
    boomboxCount,
    Float:boomboxPos[3],
    Text3D:boomboxLabel,
    boomboxObject
};

new boomboxData[MAX_BOOMBOX][kutuVeri];

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, boomboxData[playerid][boomboxPos][0], boomboxData[playerid][boomboxPos][1], boomboxData[playerid][boomboxPos][2]))
        {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX_SARKI, DIALOG_STYLE_INPUT, "{ffffff}Boombox Sarki Ekrani", "{ffffff}Acmak istediginiz sarkinin urlsini asagiya yapistiriniz:", "Tamam", "");

            return 1;
        }
    }
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case DIALOG_BOOMBOX_SARKI:
        {
            new Float:PlayerPos[3];
            
            GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);

            PlayAudioStreamForPlayer(playerid, inputtext, PlayerPos[0], PlayerPos[1], PlayerPos[2], 10.0, true);

            SendClientMessage(playerid, MESAJ_RENK, "Boombox uzerinden bir sarki actiniz, keyifli dinlemeler!");
        }
    }
    return 1;
}

CMD:boomboxolustur(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
        SendClientMessage(playerid, MESAJ_RENK, "Admin degilsin!");

    if(sscanf(params, "s[32]", boomboxData[playerid][boomboxName]))
        return SendClientMessage(playerid, MESAJ_RENK, "/boomboxolustur [isim]");
    
    if(playerid == MAX_BOOMBOX)
        return SendClientMessage(playerid, MESAJ_RENK, "Daha fazla boombox olusturamazsiniz.");

    GetPlayerPos(playerid, boomboxData[playerid][boomboxPos][0], boomboxData[playerid][boomboxPos][1], boomboxData[playerid][boomboxPos][2]);

    boomboxData[playerid][boomboxObject] = CreateObject(2226, boomboxData[playerid][boomboxPos][0], boomboxData[playerid][boomboxPos][1], boomboxData[playerid][boomboxPos][2], 0.0, 0.0, 0.0, 50.0);
       
    boomboxData[playerid][boomboxLabel] = Create3DTextLabel(boomboxData[playerid][boomboxName], -1, boomboxData[playerid][boomboxPos][0], boomboxData[playerid][boomboxPos][1], boomboxData[playerid][boomboxPos][2], 100.0, -1, 0);

    boomboxData[playerid][boomboxCount]++;

    new String[128];

    format(String, sizeof(String), "Boombox olusturuldu, id: %i", boomboxData[playerid][boomboxCount]);

    SendClientMessage(playerid, MESAJ_RENK, String);

    return 1;
}

// mysql olmadığı için id konusunda sikintili mysql baglayarak kendiniz yapabilirsiniz :)

CMD:boomboxsil(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
        SendClientMessage(playerid, MESAJ_RENK, "Admin degilsin!");
   
    if(sscanf(params, "i", boomboxData[playerid][boomboxCount]))
        return SendClientMessage(playerid, MESAJ_RENK, "/boomboxsil [id]");

    if(boomboxData[playerid][boomboxCount] != 1)
        return SendClientMessage(playerid, MESAJ_RENK, "Boyle bir boombox yok.");

    DestroyObject(boomboxData[playerid][boomboxObject]);

    boomboxData[playerid][boomboxCount]--;

    SendClientMessage(playerid, MESAJ_RENK, "Boombox basariyla silindi.");

    return 1;
}

CMD:boomboxsarkikapat(playerid, params[])
{
    #pragma unused params

    StopAudioStreamForPlayer(playerid);

    SendClientMessage(playerid, MESAJ_RENK, "Boombox basarili bir sekilde kapatildi!");
    return 1;
}
