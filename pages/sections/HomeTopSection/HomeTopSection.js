import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { styled } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Paper from "@mui/material/Paper";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import styles from "./hometopsection.module.css";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";

const abiLandloard = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_address",
        type: "address",
      },
    ],
    name: "addTenant",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "isOwner",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "my_tenants",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "payRent",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "tenants",
    outputs: [
      {
        internalType: "address payable",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === "dark" ? "#1A2027" : "#fff",
  ...theme.typography.fontWeightBold,
  padding: theme.spacing(1),
  textAlign: "center",
  color: theme.palette.text.secondary,
  margin: "auto",
  maxWidth: 500,
}));
const HomeTopSection = () => {
  const [isConnected, setIsConnected] = useState(false);
  const [hasMetamask, setHasMetamask] = useState(false);
  const [signer, setSigner] = useState(undefined);

  useEffect(() => {
    if (typeof window.ethereum !== "undefined") {
      setHasMetamask(true);
    }
  });

  async function connectToMetamask() {
    if (typeof window.ethereum !== "undefined") {
      try {
        await ethereum.request({ method: "eth_requestAccounts" });
        setIsConnected(true);
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        setSigner(provider.getSigner());
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false);
    }
  }

  async function ExecuteAddTenant() {
    if (typeof window.ethereum != undefined) {
      const contractAddress = "0x86b6244836273f5224905Af86cf66c5DCf537FbC";
      
      const contract = new ethers.Contract(contractAddress, abiLandloard, signer);
      try {
        let tenantTest = '0xAAB00377393a786e65CdE298b55fBF07Aaa0aD0A'
        await contract.addTenant(tenantTest);
        console.log("Tenant Added!!")
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }
  async function ExecuteGetBalance() {
    if (typeof window.ethereum != undefined) {
      const contractAddress = "0x86b6244836273f5224905Af86cf66c5DCf537FbC";
      
      const contract = new ethers.Contract(contractAddress, abiLandloard, signer);
      try {
        const landloardBalance = await contract.getBalance();
        console.log("this is the landloard balance: " + landloardBalance)
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }

  return (
    <Box className={styles.homeTopSectionBox}>
      <Item className={styles.homeTopItem}>
        <Typography className={styles.homeTopText} variant="h4" component="h4">
          What is RentFlow?
        </Typography>
        <Typography className={styles.homeMainText} variant="body1">
          RentFlow is a Business to Business rental income investing tool that
          will collect all your rental income and lend it out to DeFi plataforms
          to earn money for you. Easily receive payments from your renters, and
          let our automated system do the reallocation and heavy lifting for
          you. Best of of, you have full control of your investments.
        </Typography>
      </Item>
      <Item>
        {hasMetamask ? (
          isConnected ? (
            "Connected! "
          ) : (
            <Button onClick={() => connectToMetamask()}>
              Connect to Metamask
            </Button>
          )
        ) : (
          "Please install metamask"
        )}
        {isConnected ? <button onClick={() => ExecuteAddTenant()}>Add Tenant</button> : ""}
        {isConnected ? <button onClick={() => ExecuteGetBalance()}>Get Balance</button> : ""}
      </Item>
    </Box>
  );
};

export default HomeTopSection;
