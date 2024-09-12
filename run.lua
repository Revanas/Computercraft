os.loadAPI("inv")
while true do
  print("checking for cole")
  inv.checkFuelStatusAndRefill(6,2)
  print("clear furnaces")
  inv.emptyFurnaces()
  print("check stock for cole")
  inv.produceCharcoal(256)
  print("check for and smelt dusts")
  inv.smeltItemsInChest("minecraft:chest")
  sleep(10)
end
