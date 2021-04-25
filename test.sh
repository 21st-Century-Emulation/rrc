docker build -q -t rrc .
docker run --rm --name rrc -d -p 8080:8080 rrc

sleep 5

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"id":"abcd", "opcode":0,"state":{"a":242,"b":0,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":0,"stackPointer":0,"cycles":0}}' \
  http://localhost:8080/api/v1/execute`
EXPECTED='{"id":"abcd", "opcode":0,"state":{"a":121,"b":0,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":0,"stackPointer":0,"cycles":4}}'

docker kill rrc

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mRRC Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mRRC Test Fail  \e[0m"
    echo "$RESULT"
    echo "$EXPECTED"
    exit 1
fi