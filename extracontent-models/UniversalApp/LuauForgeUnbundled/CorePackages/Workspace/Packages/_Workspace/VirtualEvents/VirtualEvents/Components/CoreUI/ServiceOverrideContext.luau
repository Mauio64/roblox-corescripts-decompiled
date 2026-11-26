local SocialService = game:GetService("SocialService")

return require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React").createContext({ socialService = SocialService })
