import Head from "next/head"
import Image from "next/image"
import NavBar from "../components/navbar/NavBar"
import styles from "../styles/Home.module.css"
import HomeTopSection from "./sections/HomeTopSection/HomeTopSection"

export default function Home() {
  return (
    <div>
      <Head>
        <title>RentFlow</title>
        <meta
          name="description"
          content="Chainlink Hackathon 2022 - RentFlow Project"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <NavBar />
      <HomeTopSection />
    </div>
  )
}
