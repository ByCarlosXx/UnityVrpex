--########################################################--
--# INFO SPAWN ##########################################--
--########################################################--

function applyModifiesVeh(vehicle,engine,body,fuel,tuning,plate,doorsStats,winsStats,tyresStats,vname)
    if engine then SetVehicleEngineHealth(vehicle,engine+0.0) else SetVehicleEngineHealth(vehicle,1000.0) end
    if body then SetVehicleBodyHealth(vehicle,body+0.0) else SetVehicleBodyHealth(vehicle,1000.0) end
    if fuel then SetVehicleFuelLevel(vehicle,fuel+0.0) else SetVehicleFuelLevel(vehicle,100.0) end
    if plate and GetVehicleNumberPlateText(vehicle) ~= plate then 
        SetTimeout(1500,function() 
            SetVehicleNumberPlateText(vehicle,plate) 
            while GetVehicleNumberPlateText(vehicle) ~= plate do Wait(0) end
            SetTimeout(500,function() vSERVER._refreshOwnerVehicle(VehToNet(vehicle)) end)
        end) 
    end
    if doorsStats ~= nil and type(doorsStats) == "table" then for k,v in pairs(doorsStats) do if v then SetVehicleDoorBroken(vehicle,parseInt(k),parseInt(v)) end end end
    if winsStats ~= nil and type(winsStats) == "table" then for k,v in pairs(winsStats) do if not v then SmashVehicleWindow(vehicle,parseInt(k)) end end end
    if vehTyres ~= nil and type(tyresStats) == "table" then for k,v in pairs(tyresStats) do if v < 2 then SetVehicleTyreBurst(vehicle,parseInt(k),(v == 1),1000.01) end end end
    vehicleMods(vehicle,tuning)
end

function vehicleMods(veh,custom)
	if custom and veh then
		SetVehicleModKit(veh,0)
		if custom.color then
			SetVehicleColours(veh,tonumber(custom.color[1]),tonumber(custom.color[2]))
			SetVehicleExtraColours(veh,tonumber(custom.extracolor[1]),tonumber(custom.extracolor[2]))
		end
		
		if custom.customPcolor then
			SetVehicleCustomPrimaryColour(veh,custom.customPcolor[1],custom.customPcolor[2],custom.customPcolor[3])
		end

		if custom.customScolor then
			SetVehicleCustomSecondaryColour(veh,custom.customScolor[1],custom.customScolor[2],custom.customScolor[3])
		end

		if custom.smokecolor then
			ToggleVehicleMod(veh,20,true)
			SetVehicleTyreSmokeColor(veh,tonumber(custom.smokecolor[1]),tonumber(custom.smokecolor[2]),tonumber(custom.smokecolor[3]))
		end

		if custom.neon then
			SetVehicleNeonLightEnabled(veh,0,true)
			SetVehicleNeonLightEnabled(veh,1,true)
			SetVehicleNeonLightEnabled(veh,2,true)
			SetVehicleNeonLightEnabled(veh,3,true)
			SetVehicleNeonLightsColour(veh,tonumber(custom.neoncolor[1]),tonumber(custom.neoncolor[2]),tonumber(custom.neoncolor[3]))
		else
			SetVehicleNeonLightEnabled(veh,0,false)
			SetVehicleNeonLightEnabled(veh,1,false)
			SetVehicleNeonLightEnabled(veh,2,false)
			SetVehicleNeonLightEnabled(veh,3,false)
		end

		if custom.xenoncolor then
			ToggleVehicleMod(veh,22,true)
			SetVehicleXenonLightsColour(veh,tonumber(custom.xenoncolor))
		end

		if custom.plateindex then
			SetVehicleNumberPlateTextIndex(veh,tonumber(custom.plateindex))
		end

		if custom.windowtint then
			SetVehicleWindowTint(veh,tonumber(custom.windowtint))
		end

		--if custom.bulletProofTyres >= 0 then
			SetVehicleTyresCanBurst(veh,custom.bulletProofTyres)
		--end

		if custom.wheeltype then
			SetVehicleWheelType(veh,tonumber(custom.wheeltype))
		end
		if custom.mods then
			SetVehicleMod(veh,0,custom.mods["0"].mod)
			SetVehicleMod(veh,1,custom.mods["1"].mod)
			SetVehicleMod(veh,2,custom.mods["2"].mod)
			SetVehicleMod(veh,3,custom.mods["3"].mod)
			SetVehicleMod(veh,4,custom.mods["4"].mod)
			SetVehicleMod(veh,5,custom.mods["5"].mod)
			SetVehicleMod(veh,6,custom.mods["6"].mod)
			SetVehicleMod(veh,7,custom.mods["7"].mod)
			SetVehicleMod(veh,8,custom.mods["8"].mod)
			SetVehicleMod(veh,10,custom.mods["10"].mod)
			SetVehicleMod(veh,11,custom.mods["11"].mod)
			SetVehicleMod(veh,12,custom.mods["12"].mod)
			SetVehicleMod(veh,13,custom.mods["13"].mod)
			SetVehicleMod(veh,14,custom.mods["14"].mod)
			SetVehicleMod(veh,15,custom.mods["15"].mod)
			SetVehicleMod(veh,16,custom.mods["16"].mod)
			SetVehicleMod(veh,23,custom.mods["23"].mod,custom.mods["23"].variation)
			SetVehicleMod(veh,24,custom.mods["24"].mod,custom.mods["24"].variation)
			SetVehicleMod(veh,25,custom.mods["25"].mod)
			SetVehicleMod(veh,26,custom.mods["26"].mod)
			SetVehicleMod(veh,27,custom.mods["27"].mod) 
			SetVehicleMod(veh,28,custom.mods["28"].mod)
			SetVehicleMod(veh,29,custom.mods["29"].mod)
			SetVehicleMod(veh,30,custom.mods["30"].mod)
			SetVehicleMod(veh,31,custom.mods["31"].mod)
			SetVehicleMod(veh,32,custom.mods["32"].mod)
			SetVehicleMod(veh,33,custom.mods["33"].mod)
			SetVehicleMod(veh,34,custom.mods["34"].mod)
			SetVehicleMod(veh,35,custom.mods["35"].mod)
			SetVehicleMod(veh,36,custom.mods["36"].mod)
			SetVehicleMod(veh,37,custom.mods["37"].mod) 
			SetVehicleMod(veh,38,custom.mods["38"].mod)
			SetVehicleMod(veh,39,custom.mods["39"].mod)
			SetVehicleMod(veh,40,custom.mods["40"].mod)
			SetVehicleMod(veh,41,custom.mods["41"].mod)
			SetVehicleMod(veh,42,custom.mods["42"].mod)
			SetVehicleMod(veh,43,custom.mods["43"].mod)
			SetVehicleMod(veh,44,custom.mods["44"].mod)
			SetVehicleMod(veh,45,custom.mods["45"].mod)
			SetVehicleMod(veh,46,custom.mods["46"].mod)
			SetVehicleMod(veh,48,custom.mods["48"].mod)

			ToggleVehicleMod(veh,18,custom.mods["18"].mod)
		end
    end
end

