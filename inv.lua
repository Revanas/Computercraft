--inventory basic methods 

--tostring()
--tonumber()

--if <bedingung> then
--  <mach was>
--else if <bedingung> then
--  <mach was anderes>
--else
--  <mach noch was anderes>
--end

--while <bedingung> do
--  <mach was>
--end

--for <variable> = <startzahl>, <zielzahl> [,schritt] do
--  <mach was>
--end

--Variablen
--Global: <variable>=<wert>
--Lokal: local <variable>=<wert>

--nachricht="Andreas"
--print("Hallo"..name)

--function <name>(<parameter>)
--  <mach was>
--end

--peripheral.find("minecraft:chest")
--chests = { peripheral.find("minecraft:chest") }

--peripheral.getName(chest_b)

--Returns Slot, Inventory and amount
--Returns 0,nil,0 if nothing found
--item: displayname of an item e.g. "Oak Log"
--inventoryType: name of the inventory e.g. "sophisticatedstorage:limited_barrel" or "minecraft:chest"
function findItemInAllInventoriesByName(item, inventoryType)
  local result = { slot = 0, inv = nil, amount = 0 }
    chests = { peripheral.find(inventoryType) }
    --chests = { peripheral.find("minecraft:chest") }
    for k,v in pairs(chests) do
      --print("Durchsuche Kiste: "..k)
      local _result = findItemInInventoryByName(v, item)
      --print(_result["slot"])
      if (_result["slot"] ~= 0) then
        --print("Item gefunden!")
        result["slot"] = _result["slot"]
        result["inv"] = v
        result["amount"] = _result["amount"]
        return result
      end
    end
  return result
end

--Returns the slot and amount of items
--Returns 0 if no item has been found
function findItemInInventoryByName(inventory,item)
  local temp_result = { slot = 0, amount = 0 }
  for slot, _item in pairs(inventory.list()) do
    --print("Vorhandenes Item: "..textutils.serialise(_item))
    details = inventory.getItemDetail(slot)
    --print(textutils.serialise(details))
    if (details.displayName == item) then
      --print("Item gefunden!")
      temp_result["slot"] = slot
      temp_result["amount"] = details.count
      return temp_result
    end
  end
    return temp_result
end

--Returns furnaces that need refill
--expectedamount: The amount of items expected in the fuel slot. If count is below it will be returned
--slottocheck: The slot the holds the fuel, default should be 2
--amounttorefill: Define how many items should be moved
--Exampel:
--os.loadAPI("inv.lua")
--inv.checkFuelStatusAndRefill(6, 2)
function checkFuelStatusAndRefill(expectedamount, slottocheck)
  local result = {}
  local amounttobemoved = 0
  local furnaces = getFurnaces()
  for k,v in pairs(furnaces) do
    if v.getItemDetail(2) == nil then
      amounttobemoved = expectedamount
    elseif v.getItemDetail(2).count < expectedamount then
      amounttobemoved = expectedamount - v.getItemDetail(2).count
    else
      amounttobemoved = 0
    end

    if amounttobemoved > 0 then
      coal = findItemInAllInventoriesByName("Charcoal", "sophisticatedstorage:limited_barrel")
      if coal["amount"] > 0 then
        coal["inv"].pushItems(peripheral.getName(v),coal["slot"],amounttobemoved,slottocheck)
      else
        print("No Charcoal available!!!")
      end
    end
  end
end

function emptyFurnaces()
  local furnaces = { peripheral.find("minecraft:furnace") }
  local chest = peripheral.find("minecraft:chest")
  for k,v in pairs(furnaces) do
    if v.getItemDetail(2).displayName == "Charcoal" then
      findItemInAllInventoriesByName("Charcoal", "sophisticatedstorage:limited_barrel")["inv"].pullItems(peripheral.getName(v),3)
    else
      chest.pullItems(peripheral.getName(v),3)
    end
  end
end

function getFurnaces()
  return { peripheral.find("minecraft:furnace") }
end

--item: displayname of an item that should be considered
function getFreeFurnaces(item)
  local furnaces = getFurnaces()
  freefurnaces = {}
  for k,v in pairs(furnaces) do
    if v.getItemDetail(1) == nil or v.getItemDetail(1).displayName == item then
      --print("free furnace found")
      table.insert(freefurnaces,v)
    end
  end
  return freefurnaces
end

function getCurrenAmountOfItemsBeeingSmelted(item)
  local furnaces = getFurnaces()
  amount = 0
  for k,v in pairs(furnaces) do
    if v.getItemDetail(1) ~= nil then
      if v.getItemDetail(1).displayName == item then
        amount = v.getItemDetail(1).count + amount
      end
    end
  end
  return amount
end

function produceCharcoal(itemlimit)
  currentAmount = getCurrenAmountOfItemsBeeingSmelted("Oak Log") + findItemInAllInventoriesByName("Charcoal", "sophisticatedstorage:limited_barrel")["amount"]
  if currentAmount < itemlimit then
    oak = findItemInAllInventoriesByName("Oak Log", "sophisticatedstorage:limited_barrel")
    --print(oak["amount"])
    if oak["amount"] > 0 then
      furnaces = getFreeFurnaces()
      if #furnaces > 0 then
        amounttobemoved = itemlimit - currentAmount
        oak["inv"].pushItems(peripheral.getName(furnaces[1]),oak["slot"],amounttobemoved,1)
      else
        print("no free furnaces")
      end
    else
      print("no logs in stock to be burned")
    end
  else
    print("enough charcoal in stock")
  end
end

--inventoryType: e.g. "minecraft:chest"
function smeltItemsInChest(inventoryType)
  chests = { peripheral.find(inventoryType) }
  for k,inventory in pairs(chests) do
    for slot, _item in pairs(inventory.list()) do
      --print("Vorhandenes Item: "..textutils.serialise(_item))
      details = inventory.getItemDetail(slot)
      --print(textutils.serialise(details))
      if (details.tags["forge:dusts"]) then
        furnaces = getFreeFurnaces()
        if #furnaces > 0 then
          amountperfurnace = details.count / #furnaces
          print("try to smelt: "..details.displayName)
          for k,furnace in pairs(furnaces) do
            print("move: "..amountperfurnace.." of "..details.displayName.." to "..peripheral.getName(furnace)
            inventory.pushItems(peripheral.getName(furnace),slot,amountperfurnace,1)
          end
        end
      end
    end
  end
end
    
        

