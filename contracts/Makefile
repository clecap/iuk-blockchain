contract = Documents
builddir = build

.PHONY: all clean solc

all: $(builddir)/$(contract).abi $(builddir)/$(contract).bin

$(builddir)/$(contract).abi: $(contract).sol
	./solc.sh --abi --optimize --overwrite $(contract).sol -o build	

$(builddir)/$(contract).bin: $(contract).sol
	./solc.sh --bin --optimize --overwrite $(contract).sol -o build	

solc: Dockerfile
	docker build -t mysolc .	

clean:
	rm -f $(builddir)/$(contract).abi $(builddir)/$(contract).bin
