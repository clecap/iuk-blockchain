fbase = ChecksumDB
builddir = build

.PHONY: all clean

all: $(builddir)/$(fbase).abi $(builddir)/$(fbase).bin

$(builddir)/$(fbase).abi: $(fbase).sol
	./solc.sh --abi --overwrite ChecksumDB.sol -o build	

$(builddir)/$(fbase).bin: $(fbase).sol
	./solc.sh --bin --overwrite ChecksumDB.sol -o build	

solc: Dockerfile
	docker build -t mysolc .	

clean:
	rm $(builddir)/$(fbase).abi $(builddir)/$(fbase).bin
