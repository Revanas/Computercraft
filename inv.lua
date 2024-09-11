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
function findItemInAllInventoriesByName(item)
  local result = { slot = 0, inv = nil, amount = 0 }
    chests = { peripheral.find("minecraft:chest") }
    for k,v in pairs(chests) do
      print("Durchsuche Kiste: "..k)
      local _result = findItemInInventoryByName(v, item)
      --print(_result["slot"])
      if (_result["slot"] ~= 0) then
        print("Item gefunden!")
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
      print("Item gefunden!")
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
  local furnaces = { peripheral.find("minecraft:furnace") }
  for k,v in pairs(furnaces) do
    if v.getItemDetail(2) == nil then
      amountobemoved = expectedamount
    elseif v.getItemDetail(2).count < expectedamount then
      amountobemoved = expectedamount - v.getItemDetail(2).count
    else
      amountobemoved = 0
    end


      
    if v.getItemDetail(2) == nil or v.getItemDetail(2).count < expectedamount then
      coal = findItemInAllInventoriesByName("Charcoal")
      if coal["amount"] > 0 then
        if not v.getItemDetail(2) == nil or coal["amount"] >= expectedamount - v.getItemDetail(2).count then
          amountobemoved = expectedamount - v.getItemDetail(2).count
        elseif coal["amount"] <= expectedamount then
          amounttobemoved = coal["amount"]
        else
          amounttobemoved = expectedamount
        end
        coal["inv"].pushItems(peripheral.getName(v),coal["slot"],amounttobemoved,slottocheck)
      else
        print("No Charcoal available!!!")
      end
    end
  end
end
    
        

-- TEST
chest = peripheral.wrap("left")
findItemInInventoryByName(chest, "charcoal")

 
local im = peripheral.find("inventoryManager")
local cb = peripheral.find("chatBox")
 
if im == nil then error("the inventory manager not found") end
if cb == nil then error("chatBox not found") end
 
print("Running dumper")
 
while true do
 
    local e, player, msg = os.pullEvent("chat")
    if msg == "dump" and player == "toastonrye" then
        print("Dumping slots 9 through 26")
        myInv = im.getItems()
        local foo = {}
        for k,v in pairs(myInv) do
            table.insert(foo,k,v.count)  
        end
        for k,v in pairs(foo) do
            if k>=9 and k<=26 then
                print(k..": "..v)
                im.removeItemFromPlayer("EAST",v,k)
            end
        end
    end
end
