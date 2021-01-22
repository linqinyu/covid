import React from 'react';
import { NavLink } from 'react-router-dom';
import styled from 'styled-components';

import { ContentContainer, Gutter } from '../styled_components';

import Grid from '@material-ui/core/Grid';

import { StaticNavbar, Footer } from '../components';
import { colors } from '../config';

const ContactPage = styled.div`
    background:white;
`

const contact = () => {
    return (
       <ContactPage>
           <StaticNavbar/>
           <ContentContainer>
               <h1>Contact Us</h1>
               <hr/>
               <p>
                    Contact US COVID Atlas co-leads directly if you have any questions about the Atlas or have media inquiries:<br/>
                    Marynia Kolak (mkolak at uchicago.edu) or Qinyun Lin (qinyunlin at uchicago.edu)
               </p>
               <Gutter h={40}/>
               <h2>CITATION</h2>
               <hr/>
               <p>
                    Li, Xun, Lin, Qinyun, and Kolak, Marynia. The U.S. COVID-19 Atlas, 2020. https://www.uscovidatlas.org
                    <br/><br/>
                    For a list of all contributors to the Atlas, please visit our <a href="https://github.com/GeoDaCenter/covid" target="_blank" rel="noopener noreferrer">Github</a> page.
               </p>
               <Gutter h={40}/>
               <h2>LEARNING COMMUNITY</h2>
               <hr/>
               <p>
                    The <a href="https://covidatlas.healthcarecommunities.org/" target="_blank" rel="noopener noreferrer">Atlas Learning Community</a> is project by <a href="https://www.spreadinnovation.com/" target="_blank" rel="noopener noreferrer">CSI Solutions</a> to provide Atlas super-users, health practioners, and planners a place to interact. 
                    It is moderated by coalition members. Ask questions, provide feedback, and help make the Atlas Coalition stronger!
               </p>
               <Gutter h={40}/>
               <h2>MEDIA COVERAGE</h2>
               <hr/>
           </ContentContainer>
           <Footer/>
       </ContactPage>
    );
}
 
export default contact;