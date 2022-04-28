import Head from 'next/head'
import Image from 'next/image'
import NavBar from '../components/navbar/NavBar'
import styles from '../styles/Home.module.css'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>RentFlow</title>
        <meta name="description" content="Chainlink Hackathon 2022 - RentFlow Project" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <NavBar/>
      <h1>main body</h1>
    </div>
  )
}
