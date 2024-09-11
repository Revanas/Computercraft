os.loadAPI("inv")
while true do
  print("checking for cole")
  inv.checkFuelStatusAndRefill(6,2)
  inv.emptyFurnaces()
  sleep(10)
end
