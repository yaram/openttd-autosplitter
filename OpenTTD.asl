state("OpenTTD") {
    string6 Revision112 : "openttd.exe", 0x00629f4c; // _openttd_revision for 1.11.2

    string6 Revision121 : "openttd.exe", 0x007d2394; // _openttd_revision for 1.12.1

    string6 Revision131 : "openttd.exe", 0x00949D24; // _openttd_revision for 1.13.1

    string7 Revision134 : "openttd.exe", 0x00B5A6F8, 0x9B8; // _openttd_revision for 1.13.4
}



state("OpenTTD", "1.11.2") {
    int GameMode : "openttd.exe", 0x007d17e0; // _game_mode
    int SwitchMode : "openttd.exe", 0x007c17e4; // _switch_mode

    long Money : "openttd.exe", 0x00762030, 0, 0x60; // _company_pool.data[0]->money
    long Loan : "openttd.exe", 0x00762030, 0, 0x70; // _company_pool.data[0]->current_loan
    long TotalScore : "openttd.exe", 0x007c1128; // _score_part[0][9]
}

state("OpenTTD", "1.12.1") {
    int GameMode : "openttd.exe", 0x009a7ed8; // _game_mode
    int SwitchMode : "openttd.exe", 0x009a7ee0; // _switch_mode

    long Money : "openttd.exe", 0x0094f5a0, 0, 0x58; // _company_pool.data[0]->money
    long Loan : "openttd.exe", 0x0094f5a0, 0, 0x68; // _company_pool.data[0]->current_loan
    long TotalScore : "openttd.exe", 0x009a7a28; // _score_part[0][9]
}

state("OpenTTD", "1.13.1") {
    int GameMode : "openttd.exe", 0x00B5492C; // _game_mode
    int SwitchMode : "openttd.exe", 0x00B54AC4; // _switch_mode

    long Money : "openttd.exe", 0x00AFC2D0, 0, 0x58; // _company_pool.data[0]->money
    long Loan : "openttd.exe", 0x00AFC2D0, 0, 0x68; // _company_pool.data[0]->current_loan
    long TotalScore : "openttd.exe", 0x00B54258; // _score_part[0][9]
}

state("OpenTTD", "1.13.4") {
    int GameMode : "openttd.exe", 0x00B57A8C; // _game_mode
    int SwitchMode : "openttd.exe", 0x00B57AB0; // _switch_mode

    long Money : "openttd.exe", 0x00AFF2D0, 0, 0x58; // _company_pool.data[0]->money
    long Loan : "openttd.exe", 0x00AFF2D0, 0, 0x68; // _company_pool.data[0]->current_loan
    long TotalScore : "openttd.exe", 0x00B57328; // _score_part[0][9]
}

startup {
    settings.Add("reset", false, "Reset on return to menu");
    settings.Add("start", false, "Start on level loaded");

    settings.Add("loan", false, "Split on loan repayed");

    settings.Add("1e6", false, "Split on 1,000,000 earned");

    settings.Add("score90", false, "Split on total score of 90% (900)");
    settings.Add("score100", false, "Split on total score of 100% (1,000)");
}

init {
    if(current.Revision112 == "1.11.2") {
        version = "1.11.2";
    } else if(current.Revision121 == "12.1") {
        version = "1.12.1";
    } else if(current.Revision131 == "13.1") {
        version = "1.13.1";
    }else if(current.Revision134 == "TD 13.4") {
        version = "1.13.4";
    }
}

reset {
    if(settings["reset"] && current.GameMode == 0 /* GM_MENU */) {
        return true;
    }

    return false;
}

start {
    if(settings["start"] && current.GameMode == 1 /* GM_NORMAL */ && current.SwitchMode == 0 /* SM_NONE */ && old.SwitchMode == 1 /* SM_NEWGAME */) {
        return true;
    }

    return false;
}

split {
    if(current.GameMode == 1) {
        if(settings["loan"] && current.Loan == 0 && old.Loan != 0) {
            return true;
        }

        if(settings["1e6"] && current.Money >= 1000000 && old.Money < 1000000) {
            return true;
        }

        if(settings["score90"] && current.TotalScore >= 900 && old.TotalScore < 900) {
            return true;
        }

        if(settings["score100"] && current.TotalScore >= 1000 && old.TotalScore < 1000) {
            return true;
        }
    }

    return false;
}
