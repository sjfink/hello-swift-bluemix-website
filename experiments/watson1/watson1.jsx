import { Jumbotron, Footer } from 'watson-react-components';

ReactDOM.render(
        <Jumbotron
        serviceName="Demo title"
        repository="https://github.com/watson-developer-cloud/react-components"
        documentation="https://www.ibm.com/watson/developercloud/doc/visual-recognition/"
        apiReference="https://www.ibm.com/watson/developercloud/visual-recognition/api/v3"
        startInBluemix="https://console.ng.bluemix.net/registration/?target=/catalog/services/visual-recognition/"
        version="Beta"
        serviceIcon="images/service-icon.svg"
        description="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        />,
        document.getElementById('app')
        );


ReactDOM.render(
        <Footer />,
        document.getElementById('footer')
        );
