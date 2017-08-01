package gov.medicaid.process.enrollment

//import org.springframework.web.client.RestTemplate
import spock.lang.Specification

class ExcludedProvidersScreeningHandlerTest extends Specification {
    def "can create instance of handler"() {
        given:
        def handler = new ExcludedProvidersScreeningHandler("http://localhost:5000/")

        expect:
        handler != null
    }

    def "handler makes request of localhost"() {
        given:
        def handler = new ExcludedProvidersScreeningHandler("http://localhost:5000/")
        def npi = "1093169518"

        when:
        boolean result = handler.providerInLEIE(npi)

        then:
        result
    }
}
