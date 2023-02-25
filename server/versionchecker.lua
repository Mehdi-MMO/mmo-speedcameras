local Version = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
local Repository = 'https://raw.githubusercontent.com/Mehdi-MMO/mmo-speedcameras/main/version.txt'

AddEventHandler('onResourceStart', function(ResourceName)
    Wait(5000)
    if ResourceName == GetCurrentResourceName() then
        PerformHttpRequest(Repository, function(Error, NewestVersion, Header)
            if Error == 200 then

                NewestVersion = string.gsub(NewestVersion, '\n', '')

                if NewestVersion ~= Version then
                    print(
                        "\n\n^1[WARNING]^3 The script is outdated v(" .. Version .. ") Please download the latest version v(" .. NewestVersion .. ") Resfrom the Mehdi MMO's GitHub")
                    print(
                        "                  ^2Github Link: ^9https://github.com/Mehdi-MMO/mmo-speedcameras/releases \n\n")
                end
            else
                print("\n\n^1[ERROR]^3 Failed to check for updates.\n")
            end
        end)
    end
end)
