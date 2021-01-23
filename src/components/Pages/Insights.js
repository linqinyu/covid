import React, { useState, useEffect } from 'react';
import { NavLink } from 'react-router-dom';
import styled from 'styled-components';
import { ContentContainer, Gutter } from '../../styled_components';
import { StaticNavbar, Footer } from '../';
import { colors } from '../../config';

const InsightsPage = styled.div`
    background:white;
    min-height:100vh;
    .transferInfo {
        a {
            background:none;
            border:none;
            padding:10px;
            cursor:pointer;
            h2 {
                color: ${colors.blue};
                padding:0;
                margin:0;
            }
        }
    }
    footer {
        position:absolute;
        bottom:0;
    }
`

const Insights = () => {

    const [ timer, setTimer] = useState(8)

    const doTransfer = () => {
        window.location.href = 'https://medium.com/covidatlas';
    }
    
    useEffect(() => {
        setInterval(()=>{
            setTimer(prev => prev-1)
        },1000)
    }, [])

    useEffect(() => {
        if (timer===0) doTransfer()
    }, [timer])

    return (
       <InsightsPage>
           <StaticNavbar/>
           <ContentContainer className="transferInfo">
                <h1>US Covid Atlas Insights Blog</h1>
                <p>You are being redirected to Medium.com in {timer} seconds...</p>
                <NavLink to="/"><h2>Click here to remain on USCovidAtlas.org</h2></NavLink>
           </ContentContainer>
           <Footer/>
       </InsightsPage>
    );
}
 
export default Insights;