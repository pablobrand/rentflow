import { useState, useEffect } from "react";
import { ethers } from "ethers";
import Box from "@mui/material/Box";
import styles from "./rentertopsection.module.css";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import { abiLandloard } from "../abiVariables";
import { contractAddress } from "../globalInfo";
// const Item = styled(Paper)(({ theme }) => ({
//   padding: theme.spacing(2),
//   textAlign: "center",
//   color: theme.palette.text.secondary,
//   margin: "auto",
//   maxWidth: 500,
//   background: "rgba(12, 27, 48, 0.2)",
// }));

const RenterTopSection = () => {
  const [isConnected, setIsConnected] = useState(false);
  const [hasMetamask, setHasMetamask] = useState(false);
  const [signer, setSigner] = useState(undefined);
  const [accountAddress, setAccountAddress] = useState();

  useEffect(() => {
    if (typeof window.ethereum !== "undefined") {
      setHasMetamask(true);
    }
  });
  async function getAddressDetails() {
    if (typeof window.ethereum !== "undefined") {
      try {
        const accounts = await ethereum.enable();
        const account = accounts[0];
        setAccountAddress(account);
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false);
    }
  }

  //check if address is a tenant
  async function checkTenant() {
    if (typeof window.ethereum != undefined) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      setSigner(provider.getSigner());
      const contract = new ethers.Contract(
        contractAddress,
        abiLandloard,
        signer
      );
      try {
        ethereum
        .request({
          method: "eth_sendTransaction",
          params: [
            {
              from: accountAddress,
              to: contractAddress,
              value: "100000000000000"
            },
          ],
        })
        .then((txHash) => console.log(JSON.stringify(txHash)))
        .catch((error) => console.error);
        const payRentMessage = await contract.payRent();
        console.log("value returned from payRent(): " + payRentMessage);
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }

  return (
    <Box className={styles.renterTopBox}>
      <Container>
        {hasMetamask ? (
          isConnected ? (
            "Connected! "
          ) : (
            <div className={styles.renterDetailsDiv}>
              <Typography variant="h4">
                Click "Get Details" to get your details for your Account.
              </Typography>
              <Button
                variant="contained"
                color="success"
                onClick={() => getAddressDetails()}
              >
                Get Details
              </Button>
              <h2> signer value: {accountAddress}</h2>
              <Button
                variant="contained"
                color="success"
                onClick={() => checkTenant()}
              >
                Make Payment
              </Button>
            </div>
          )
        ) : (
          "Connection with metamask lost, please reconnect"
        )}
      </Container>
    </Box>
  );
};

export default RenterTopSection;
