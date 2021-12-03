FROM maven:3.8-openjdk-16 as builder

WORKDIR /
RUN git clone https://github.com/aktionariat/walletconnect-bridge.git && \
    cd walletconnect-bridge && \
    mvn package

FROM openjdk:16

COPY --from=builder /walletconnect-bridge/target target
CMD ["java", "-cp", "target/bridge.jar:target/dependency/*", "com.aktionariat.bridge.BridgeServer"]
